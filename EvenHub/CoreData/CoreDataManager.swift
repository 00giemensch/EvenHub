//
//  CoreDataManager.swift
//  EvenHub
//
//  Created by Евгений Васильев on 17.09.2025.
//
//  CoreDataManager.swift
//  EvenHub
//
//  Created by Евгений Васильев on 17.09.2025.
//

import Foundation
import CoreData
import UIKit
import FirebaseAuth

final class CoreDataManager {
    
    // MARK: - Singleton
    
    static let shared = CoreDataManager()
    private init() {}
    
    // MARK: - Core Data Stack
    
    private lazy var context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate not found")
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    // MARK: - User Management
    
    private func currentUserID() -> String {
        return Auth.auth().currentUser?.uid ?? "anonymous"
    }
    
    // MARK: - Context Management
    
    private func saveContext() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
            print("✅ Контекст успешно сохранен")
        } catch {
            print("❌ Ошибка сохранения контекста: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Clear User Data
    func clearUserData() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let request: NSFetchRequest<FavoriteEvent> = FavoriteEvent.fetchRequest()
        request.predicate = NSPredicate(format: "userID == %@", userID)
        
        do {
            let userEvents = try context.fetch(request)
            for event in userEvents {
                deleteEventWithRelations(event)
            }
            saveContext()
            print("✅ Данные пользователя \(userID) очищены")
        } catch {
            print("❌ Ошибка очистки данных пользователя: \(error)")
        }
    }
}

// MARK: - Event Caching (Для главного экрана)
extension CoreDataManager {
    
    /// Кэширует массив событий с полными relationships
    func cacheEvents(_ events: [EventDTO], cacheKey: String = "main_events") {
        clearCachedEvents(cacheKey: cacheKey)
        
        for eventDTO in events {
            let cachedEvent = FavoriteEvent(context: context)
            configureEvent(cachedEvent, with: eventDTO)
            cachedEvent.cacheKey = cacheKey
            cachedEvent.isCached = true
            cachedEvent.cachedDate = Date()
            cachedEvent.userID = currentUserID()
        }
        
        saveContext()
        print("✅ Закэшировано событий: \(events.count) для ключа: \(cacheKey)")
    }
    
    /// Получает закэшированные события
    func getCachedEvents(cacheKey: String = "main_events", limit: Int? = nil) -> [FavoriteEvent] {
        let request: NSFetchRequest<FavoriteEvent> = FavoriteEvent.fetchRequest()
        request.predicate = NSPredicate(
            format: "cacheKey == %@ AND isCached == true AND userID == %@",
            cacheKey, currentUserID()
        )
        request.sortDescriptors = [NSSortDescriptor(key: "cachedDate", ascending: false)]
        request.relationshipKeyPathsForPrefetching = ["place", "eventLocation", "images", "participants"]
        
        if let limit = limit {
            request.fetchLimit = limit
        }
        
        do {
            let events = try context.fetch(request)
            print("✅ Загружено закэшированных событий: \(events.count)")
            return events
        } catch {
            print("❌ Ошибка загрузки кэша: \(error.localizedDescription)")
            return []
        }
    }
    
    /// Проверяет актуальность кэша
    func isCacheValid(cacheKey: String = "main_events", maxAge: TimeInterval = 3600) -> Bool {
        let request: NSFetchRequest<FavoriteEvent> = FavoriteEvent.fetchRequest()
        request.predicate = NSPredicate(
            format: "cacheKey == %@ AND isCached == true AND userID == %@",
            cacheKey, currentUserID()
        )
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(key: "cachedDate", ascending: false)]
        
        do {
            guard let lastCachedEvent = try context.fetch(request).first,
                  let cacheDate = lastCachedEvent.cachedDate else {
                return false
            }
            
            return Date().timeIntervalSince(cacheDate) < maxAge
        } catch {
            print("❌ Ошибка проверки кэша: \(error.localizedDescription)")
            return false
        }
    }
    
    /// Очищает кэш для указанного ключа
    func clearCachedEvents(cacheKey: String) {
        let request: NSFetchRequest<FavoriteEvent> = FavoriteEvent.fetchRequest()
        request.predicate = NSPredicate(
            format: "cacheKey == %@ AND isCached == true AND userID == %@",
            cacheKey, currentUserID()
        )
        request.includesPropertyValues = false
        
        do {
            let eventsToDelete = try context.fetch(request)
            for event in eventsToDelete {
                if event.isFavorite {
                    event.cacheKey = nil
                    event.isCached = false
                } else {
                    deleteEventWithRelations(event)
                }
            }
            saveContext()
            print("✅ Кэш очищен для ключа: \(cacheKey)")
        } catch {
            print("❌ Ошибка очистки кэша: \(error.localizedDescription)")
        }
    }
    
    /// Возвращает количество закэшированных событий
    func getCachedEventsCount(cacheKey: String? = nil) -> Int {
        let request: NSFetchRequest<FavoriteEvent> = FavoriteEvent.fetchRequest()
        
        if let cacheKey = cacheKey {
            request.predicate = NSPredicate(
                format: "cacheKey == %@ AND isCached == true AND userID == %@",
                cacheKey, currentUserID()
            )
        } else {
            request.predicate = NSPredicate(
                format: "isCached == true AND userID == %@",
                currentUserID()
            )
        }
        
        do {
            return try context.count(for: request)
        } catch {
            print("❌ Ошибка подсчета кэша: \(error.localizedDescription)")
            return 0
        }
    }
}

// MARK: - Favorites Management (Избранное)
extension CoreDataManager {
    
    /// Добавляет событие в избранное из DTO с полными relationships
    func addToFavorites(from eventDTO: EventDTO) -> Bool {
        let eventId = "\(eventDTO.id)"
        
        guard !isEventFavorite(eventId: eventId) else {
            print("⚠️ Событие уже в избранном: \(eventDTO.title)")
            return false
        }
        
        if let existingEvent = getEvent(by: eventId) {
            existingEvent.isFavorite = true
            existingEvent.addedDate = Date()
            updateEventRelations(existingEvent, with: eventDTO)
        } else {
            let favoriteEvent = FavoriteEvent(context: context)
            configureEvent(favoriteEvent, with: eventDTO)
            favoriteEvent.isFavorite = true
            favoriteEvent.addedDate = Date()
            favoriteEvent.isCached = false
            favoriteEvent.userID = currentUserID()
        }
        
        saveContext()
        print("✅ Добавлено в избранное: \(eventDTO.title)")
        return true
    }
    
    /// Удаляет событие из избранного
    func removeFromFavorites(eventId: String) -> Bool {
        guard let event = getEvent(by: eventId), event.isFavorite else {
            print("❌ Событие не найдено в избранном: \(eventId)")
            return false
        }
        
        if event.isCached {
            event.isFavorite = false
            event.addedDate = nil
        } else {
            deleteEventWithRelations(event)
        }
        
        saveContext()
        print("✅ Удалено из избранного: \(event.title ?? "Unknown")")
        return true
    }
    
    /// Переключает статус избранного для события
    func toggleFavorite(for eventDTO: EventDTO) -> Bool {
        let eventId = "\(eventDTO.id)"
        
        if isEventFavorite(eventId: eventId) {
            return removeFromFavorites(eventId: eventId)
        } else {
            return addToFavorites(from: eventDTO)
        }
    }
    
    /// Проверяет, находится ли событие в избранном
    func isEventFavorite(eventId: String) -> Bool {
        let request: NSFetchRequest<FavoriteEvent> = FavoriteEvent.fetchRequest()
        request.predicate = NSPredicate(
            format: "id == %@ AND isFavorite == true AND userID == %@",
            eventId, currentUserID()
        )
        
        do {
            return try context.count(for: request) > 0
        } catch {
            print("❌ Ошибка проверки избранного: \(error.localizedDescription)")
            return false
        }
    }
    
    /// Проверяет, находится ли событие DTO в избранном
    func isEventFavorite(_ eventDTO: EventDTO) -> Bool {
        return isEventFavorite(eventId: "\(eventDTO.id)")
    }
    
    /// Возвращает все избранные события
    func getAllFavoriteEvents() -> [FavoriteEvent] {
        let request: NSFetchRequest<FavoriteEvent> = FavoriteEvent.fetchRequest()
        request.predicate = NSPredicate(
            format: "isFavorite == true AND userID == %@",
            currentUserID()
        )
        request.sortDescriptors = [NSSortDescriptor(key: "addedDate", ascending: false)]
        request.relationshipKeyPathsForPrefetching = ["place", "eventLocation", "images", "participants"]
        
        do {
            let favorites = try context.fetch(request)
            print("✅ Загружено избранных событий: \(favorites.count)")
            return favorites
        } catch {
            print("❌ Ошибка загрузки избранного: \(error.localizedDescription)")
            return []
        }
    }
    
    /// Возвращает количество избранных событий
    func getFavoritesCount() -> Int {
        let request: NSFetchRequest<FavoriteEvent> = FavoriteEvent.fetchRequest()
        request.predicate = NSPredicate(
            format: "isFavorite == true AND userID == %@",
            currentUserID()
        )
        
        do {
            return try context.count(for: request)
        } catch {
            print("❌ Ошибка подсчета избранного: \(error.localizedDescription)")
            return 0
        }
    }
    
    /// Очищает все избранные события
    func clearAllFavorites() {
        let request: NSFetchRequest<FavoriteEvent> = FavoriteEvent.fetchRequest()
        request.predicate = NSPredicate(
            format: "isFavorite == true AND userID == %@",
            currentUserID()
        )
        request.includesPropertyValues = false
        
        do {
            let favorites = try context.fetch(request)
            for favorite in favorites {
                if favorite.isCached {
                    favorite.isFavorite = false
                    favorite.addedDate = nil
                } else {
                    deleteEventWithRelations(favorite)
                }
            }
            saveContext()
            print("✅ Все избранные события удалены")
        } catch {
            print("❌ Ошибка удаления избранного: \(error.localizedDescription)")
        }
    }
}

// MARK: - Search Operations
extension CoreDataManager {
    
    /// Ищет события в кэше по тексту с учетом relationships
    func searchCachedEvents(searchText: String, cacheKey: String? = nil) -> [FavoriteEvent] {
        let request: NSFetchRequest<FavoriteEvent> = FavoriteEvent.fetchRequest()
        
        var predicates: [NSPredicate] = [
            NSPredicate(format: "isCached == true"),
            NSPredicate(format: "userID == %@", currentUserID())
        ]
        
        if let cacheKey = cacheKey {
            predicates.append(NSPredicate(format: "cacheKey == %@", cacheKey))
        }
        
        let searchPredicate = NSCompoundPredicate(
            orPredicateWithSubpredicates: [
                NSPredicate(format: "title CONTAINS[cd] %@", searchText),
                NSPredicate(format: "eventDescription CONTAINS[cd] %@", searchText),
                NSPredicate(format: "place.address CONTAINS[cd] %@", searchText),
                NSPredicate(format: "eventLocation.name CONTAINS[cd] %@", searchText),
                NSPredicate(format: "participants.agent.title CONTAINS[cd] %@", searchText)
            ]
        )
        
        predicates.append(searchPredicate)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.sortDescriptors = [NSSortDescriptor(key: "cachedDate", ascending: false)]
        request.relationshipKeyPathsForPrefetching = ["place", "eventLocation", "images", "participants"]
        
        do {
            return try context.fetch(request)
        } catch {
            print("❌ Ошибка поиска: \(error.localizedDescription)")
            return []
        }
    }
}

// MARK: - Relationship Management
extension CoreDataManager {
    
    /// Настраивает объект события из DTO со всеми relationships
    private func configureEvent(_ event: FavoriteEvent, with dto: EventDTO) {
        // Основные данные
        event.id = "\(dto.id)"
        event.title = dto.title
        event.eventDescription = dto.description
        event.bodyText = dto.bodyText
        event.favoritesCount = Int32(dto.favoritesCount ?? 0)
        event.startDate = dto.dates.first?.startDate
        event.startTime = dto.dates.first?.startTime
        event.endTime = dto.dates.first?.endTime
        event.userID = currentUserID()
        
        // Место (Place)
        if let placeDTO = dto.place {
            let placeEntity = PlaceEntity(context: context)
            placeEntity.id = Int32(placeDTO.id)
            placeEntity.title = placeDTO.title
            placeEntity.slug = placeDTO.slug
            placeEntity.address = placeDTO.address
            placeEntity.location = placeDTO.location
            // Координаты
            let coordsEntity = CoordinatesEntity(context: context)
            coordsEntity.lat = placeDTO.coords.lat
            coordsEntity.lon = placeDTO.coords.lon
            placeEntity.coordinates = coordsEntity
            
            event.place = placeEntity
        }
        
        // Локация события
        if let locationDTO = dto.location {
            let locationEntity = EventLocationEntity(context: context)
            locationEntity.slug = locationDTO.slug
            locationEntity.name = locationDTO.name
            event.eventLocation = locationEntity
        }
        
        // Изображения
        if !dto.images.isEmpty {
            for imageDTO in dto.images {
                if let imageUrl = imageDTO.image {
                    let imageEntity = ImagesEntity(context: context)
                    imageEntity.image = imageUrl
                    event.addToImages(imageEntity)
                }
            }
        }
        
        // Участники
        if let participantsDTO = dto.participants, !participantsDTO.isEmpty {
            for participantDTO in participantsDTO {
                let participantEntity = ParticipantEntity(context: context)
                participantEntity.roleSlug = participantDTO.role?.slug
                
                // Агент участника
                if let agentDTO = participantDTO.agent {
                    let agentEntity = AgentEntity(context: context)
                    agentEntity.id = Int32(agentDTO.id)
                    agentEntity.title = agentDTO.title
                    
                    // Изображения агента
                    if let agentImages = agentDTO.images, !agentImages.isEmpty {
                        for agentImageDTO in agentImages {
                            if let agentImageUrl = agentImageDTO.image {
                                let agentImageEntity = ImagesEntity(context: context)
                                agentImageEntity.image = agentImageUrl
                                agentEntity.addToImages(agentImageEntity)
                            }
                        }
                    }
                    participantEntity.agent = agentEntity
                    event.addToParticipants(participantEntity)
                }
            }
        }
    }
    
    /// Обновляет relationships существующего события
    private func updateEventRelations(_ event: FavoriteEvent, with dto: EventDTO) {
        // Удаляем старые relationships
        if let place = event.place {
            context.delete(place)
        }
        if let eventLocation = event.eventLocation {
            context.delete(eventLocation)
        }
        
        // Удаляем изображения
        if let images = event.images?.allObjects as? [ImagesEntity] {
            for image in images {
                context.delete(image)
            }
        }
        
        // Удаляем участников и их агентов
        if let participants = event.participants?.allObjects as? [ParticipantEntity] {
            for participant in participants {
                if let agent = participant.agent {
                    context.delete(agent)
                }
                context.delete(participant)
            }
        }
        
        // Создаем новые relationships
        configureEvent(event, with: dto)
    }
    
    /// Удаляет событие со всеми связанными объектами
    private func deleteEventWithRelations(_ event: FavoriteEvent) {
        if let place = event.place {
            context.delete(place)
        }
        if let eventLocation = event.eventLocation {
            context.delete(eventLocation)
        }
        
        // Удаляем изображения
        if let images = event.images?.allObjects as? [ImagesEntity] {
            for image in images {
                context.delete(image)
            }
        }
        
        // Удаляем участников и их агентов
        if let participants = event.participants?.allObjects as? [ParticipantEntity] {
            for participant in participants {
                if let agent = participant.agent {
                    context.delete(agent)
                }
                context.delete(participant)
            }
        }
        
        context.delete(event)
    }
}

// MARK: - Debug & Utilities
extension CoreDataManager {
    
    /// Выводит статус базы данных
    func checkDatabaseStatus() {
        let cachedCount = getCachedEventsCount()
        let favoritesCount = getFavoritesCount()
        
        print("📊 Статус базы данных:")
        print("   Закэшировано событий: \(cachedCount)")
        print("   В избранном: \(favoritesCount)")
        
        // Дополнительная статистика
        let placeCount = try? context.count(for: PlaceEntity.fetchRequest())
        let agentCount = try? context.count(for: AgentEntity.fetchRequest())
        print("   Мест: \(placeCount ?? 0)")
        print("   Агентов: \(agentCount ?? 0)")
    }
    
    /// Возвращает событие по ID (независимо от статуса)
    private func getEvent(by eventId: String) -> FavoriteEvent? {
        let request: NSFetchRequest<FavoriteEvent> = FavoriteEvent.fetchRequest()
        request.predicate = NSPredicate(
            format: "id == %@ AND userID == %@",
            eventId, currentUserID()
        )
        request.relationshipKeyPathsForPrefetching = ["place", "eventLocation", "images", "participants"]
        
        do {
            return try context.fetch(request).first
        } catch {
            print("❌ Ошибка поиска события: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Полностью очищает всю базу данных (только для дебага!)
    func clearEntireDatabase() {
        let entities = [
            FavoriteEvent.entity(),
            PlaceEntity.entity(),
            EventLocationEntity.entity(),
            ImagesEntity.entity(),
            ParticipantEntity.entity(),
            AgentEntity.entity(),
            CoordinatesEntity.entity()
        ]
        
        for entity in entities {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!))
            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch {
                print("❌ Ошибка очистки entity \(entity.name!): \(error.localizedDescription)")
            }
        }
        
        print("✅ Вся база данных очищена")
    }
}
