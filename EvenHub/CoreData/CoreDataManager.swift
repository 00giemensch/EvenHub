//
//  CoreDataManager.swift
//  EvenHub
//
//  Created by Евгений Васильев on 17.09.2025.
//
import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    // MARK: - Singleton
    static let shared = CoreDataManager()
    
    private init() {}
    
    // MARK: - Core Data Stack
    
    private var context: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate not found")
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Save Context
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                print("✅ Контекст успешно сохранен")
            } catch {
                print("❌ Ошибка сохранения контекста: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Event Cache Operations (для главного экрана)
    
    func cacheEvents(_ events: [EventDTO], cacheKey: String = "main_events") {
        clearCachedEvents(cacheKey: cacheKey)
        for eventDTO in events {
            let cachedEvent = FavoriteEvent(context: context)
            cachedEvent.id = "\(eventDTO.id)"
            cachedEvent.title = eventDTO.title
            cachedEvent.eventDescription = eventDTO.description
            cachedEvent.bodyText = eventDTO.bodyText
            cachedEvent.favoritesCount = Int32(eventDTO.favoritesCount ?? 0)
            cachedEvent.startDate = eventDTO.dates.first?.startDate
            cachedEvent.startTime = eventDTO.dates.first?.startTime
            cachedEvent.endTime = eventDTO.dates.first?.endTime
            cachedEvent.setValue(cacheKey, forKey: "cacheKey")
            cachedEvent.setValue(Date(), forKey: "cachedDate")
            cachedEvent.setValue(true, forKey: "isCached")
            cachedEvent.setValue(false, forKey: "isFavorite")
            if let placeDTO = eventDTO.place {
                let placeEntity = PlaceEntity(context: context)
                placeEntity.id = Int32(placeDTO.id)
                placeEntity.title = placeDTO.title
                placeEntity.slug = placeDTO.slug
                placeEntity.address = placeDTO.address
                placeEntity.setValue(placeDTO.location, forKey: "location")
                let coordsEntity = CoordinatesEntity(context: context)
                coordsEntity.lat = placeDTO.coords.lat
                coordsEntity.lon = placeDTO.coords.lon
                placeEntity.coordinates = coordsEntity
                cachedEvent.place = placeEntity
            }
            if let locationDTO = eventDTO.location {
                let locationEntity = EventLocationEntity(context: context)
                locationEntity.slug = locationDTO.slug
                locationEntity.name = locationDTO.name
                cachedEvent.eventLocation = locationEntity
            }
            for imageDTO in eventDTO.images {
                if let imageUrl = imageDTO.image {
                    let imageEntity = ImagesEntity(context: context)
                    imageEntity.image = imageUrl
                    cachedEvent.addToImages(imageEntity)
                }
            }
            if let participantsDTO = eventDTO.participants {
                for participantDTO in participantsDTO {
                    let participantEntity = ParticipantEntity(context: context)
                    participantEntity.roleSlug = participantDTO.role?.slug
                    if let agentDTO = participantDTO.agent {
                        let agentEntity = AgentEntity(context: context)
                        agentEntity.id = Int32(agentDTO.id)
                        agentEntity.title = agentDTO.title
                        if let agentImages = agentDTO.images {
                            for agentImageDTO in agentImages {
                                if let agentImageUrl = agentImageDTO.image {
                                    let agentImageEntity = ImagesEntity(context: context)
                                    agentImageEntity.image = agentImageUrl
                                    agentEntity.addToImages(agentImageEntity)
                                }
                            }
                        }
                        
                        participantEntity.agent = agentEntity
                    }
                    
                    cachedEvent.addToParticipants(participantEntity)
                }
            }
        }
        
        saveContext()
        print("✅ Закэшировано событий: \(events.count) для ключа: \(cacheKey)")
    }
    
    func getCachedEvents(cacheKey: String = "main_events", limit: Int? = nil) -> [FavoriteEvent] {
        let request: NSFetchRequest<FavoriteEvent> = FavoriteEvent.fetchRequest()
        request.predicate = NSPredicate(format: "cacheKey == %@ AND isCached == true", cacheKey)
        let sortDescriptor = NSSortDescriptor(key: "cachedDate", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
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
    
    func isCacheValid(cacheKey: String = "main_events", maxAge: TimeInterval = 3600) -> Bool {
        let request: NSFetchRequest<FavoriteEvent> = FavoriteEvent.fetchRequest()
        request.predicate = NSPredicate(format: "cacheKey == %@ AND isCached == true", cacheKey)
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(key: "cachedDate", ascending: false)]
        
        do {
            guard let lastCachedEvent = try context.fetch(request).first,
                  let cacheDate = lastCachedEvent.value(forKey: "cachedDate") as? Date else {
                return false
            }
            
            return Date().timeIntervalSince(cacheDate) < maxAge
        } catch {
            print("❌ Ошибка проверки кэша: \(error.localizedDescription)")
            return false
        }
    }
    
    func clearCachedEvents(cacheKey: String) {
        let request: NSFetchRequest<FavoriteEvent> = FavoriteEvent.fetchRequest()
        request.predicate = NSPredicate(format: "cacheKey == %@ AND isCached == true", cacheKey)
        
        do {
            let eventsToDelete = try context.fetch(request)
            for event in eventsToDelete {
                if !(event.value(forKey: "isFavorite") as? Bool ?? false) {
                    if let place = event.place {
                        context.delete(place)
                    }
                    if let eventLocation = event.eventLocation {
                        context.delete(eventLocation)
                    }
                    if let participants = event.participants {
                        for case let participant as ParticipantEntity in participants {
                            if let agent = participant.agent {
                                context.delete(agent)
                            }
                            context.delete(participant)
                        }
                    }
                    if let images = event.images {
                        for case let image as ImagesEntity in images {
                            context.delete(image)
                        }
                    }
                    context.delete(event)
                } else {
                    event.setValue(nil, forKey: "cacheKey")
                    event.setValue(false, forKey: "isCached")
                }
            }
            saveContext()
            print("✅ Кэш очищен для ключа: \(cacheKey)")
        } catch {
            print("❌ Ошибка очистки кэша: \(error.localizedDescription)")
        }
    }
    
    func getCachedEventsCount(cacheKey: String? = nil) -> Int {
        let request: NSFetchRequest<FavoriteEvent> = FavoriteEvent.fetchRequest()
        
        var predicate: NSPredicate
        if let cacheKey = cacheKey {
            predicate = NSPredicate(format: "cacheKey == %@ AND isCached == true", cacheKey)
        } else {
            predicate = NSPredicate(format: "isCached == true")
        }
        
        request.predicate = predicate
        
        do {
            return try context.count(for: request)
        } catch {
            print("❌ Ошибка подсчета кэша: \(error.localizedDescription)")
            return 0
        }
    }
    
    // MARK: - Favorite Operations (избранное)
    
    func addToFavorites(cachedEvent: FavoriteEvent) -> Bool {
        guard let eventId = cachedEvent.id else { return false }
        
        if isEventFavorite(eventId: eventId) {
            print("⚠️ Событие уже в избранном: \(cachedEvent.title ?? "")")
            return false
        }
        cachedEvent.setValue(true, forKey: "isFavorite")
        cachedEvent.setValue(Date(), forKey: "addedDate")
        
        saveContext()
        print("✅ Добавлено в избранное: \(cachedEvent.title ?? "")")
        return true
    }
    
    func addToFavorites(from eventDTO: EventDTO) -> Bool {
        let eventId = "\(eventDTO.id)"
        
        if isEventFavorite(eventId: eventId) {
            print("⚠️ Событие уже в избранном: \(eventDTO.title)")
            return false
        }
        
        if let cachedEvent = getCachedEvent(by: eventId) {
            cachedEvent.setValue(true, forKey: "isFavorite")
            cachedEvent.setValue(Date(), forKey: "addedDate")
        } else {
            let favoriteEvent = FavoriteEvent(context: context)
            favoriteEvent.id = eventId
            favoriteEvent.title = eventDTO.title
            favoriteEvent.eventDescription = eventDTO.description
            favoriteEvent.bodyText = eventDTO.bodyText
            favoriteEvent.favoritesCount = Int32(eventDTO.favoritesCount ?? 0)
            favoriteEvent.startDate = eventDTO.dates.first?.startDate
            favoriteEvent.startTime = eventDTO.dates.first?.startTime
            favoriteEvent.endTime = eventDTO.dates.first?.endTime
            favoriteEvent.setValue(Date(), forKey: "addedDate")
            favoriteEvent.setValue(true, forKey: "isFavorite")
            favoriteEvent.setValue(false, forKey: "isCached")
            if let placeDTO = eventDTO.place {
                let placeEntity = PlaceEntity(context: context)
                placeEntity.id = Int32(placeDTO.id)
                placeEntity.title = placeDTO.title
                placeEntity.slug = placeDTO.slug
                placeEntity.address = placeDTO.address
                placeEntity.setValue(placeDTO.location, forKey: "location")
                
                let coordsEntity = CoordinatesEntity(context: context)
                coordsEntity.lat = placeDTO.coords.lat
                coordsEntity.lon = placeDTO.coords.lon
                placeEntity.coordinates = coordsEntity
                
                favoriteEvent.place = placeEntity
            }
            if let locationDTO = eventDTO.location {
                let locationEntity = EventLocationEntity(context: context)
                locationEntity.slug = locationDTO.slug
                locationEntity.name = locationDTO.name
                favoriteEvent.eventLocation = locationEntity
            }
            for imageDTO in eventDTO.images {
                if let imageUrl = imageDTO.image {
                    let imageEntity = ImagesEntity(context: context)
                    imageEntity.image = imageUrl
                    favoriteEvent.addToImages(imageEntity)
                }
            }
            if let participantsDTO = eventDTO.participants {
                for participantDTO in participantsDTO {
                    let participantEntity = ParticipantEntity(context: context)
                    participantEntity.roleSlug = participantDTO.role?.slug
                    
                    if let agentDTO = participantDTO.agent {
                        let agentEntity = AgentEntity(context: context)
                        agentEntity.id = Int32(agentDTO.id)
                        agentEntity.title = agentDTO.title
                        
                        if let agentImages = agentDTO.images {
                            for agentImageDTO in agentImages {
                                if let agentImageUrl = agentImageDTO.image {
                                    let agentImageEntity = ImagesEntity(context: context)
                                    agentImageEntity.image = agentImageUrl
                                    agentEntity.addToImages(agentImageEntity)
                                }
                            }
                        }
                        
                        participantEntity.agent = agentEntity
                    }
                    
                    favoriteEvent.addToParticipants(participantEntity)
                }
            }
        }
        
        saveContext()
        print("✅ Добавлено в избранное: \(eventDTO.title)")
        return true
    }
    
    func removeFromFavorites(eventId: String) -> Bool {
        guard let favoriteEvent = getFavoriteEvent(by: eventId) else {
            print("❌ Событие не найдено в избранном: \(eventId)")
            return false
        }
        
        let isCached = favoriteEvent.value(forKey: "isCached") as? Bool ?? false
        
        if isCached {
            favoriteEvent.setValue(false, forKey: "isFavorite")
            favoriteEvent.setValue(nil, forKey: "addedDate")
        } else {
            deleteEventWithRelations(favoriteEvent)
        }
        
        saveContext()
        print("✅ Удалено из избранного: \(favoriteEvent.title ?? "")")
        return true
    }
    
    func toggleFavorite(from eventDTO: EventDTO) -> Bool {
        let eventId = "\(eventDTO.id)"
        
        if isEventFavorite(eventId: eventId) {
            return removeFromFavorites(eventId: eventId)
        } else {
            return addToFavorites(from: eventDTO)
        }
    }
    
    func toggleFavorite(cachedEvent: FavoriteEvent) -> Bool {
        guard let eventId = cachedEvent.id else { return false }
        
        let isFavorite = cachedEvent.value(forKey: "isFavorite") as? Bool ?? false
        
        if isFavorite {
            return removeFromFavorites(eventId: eventId)
        } else {
            return addToFavorites(cachedEvent: cachedEvent)
        }
    }
    
    func isEventFavorite(eventId: String) -> Bool {
        let request: NSFetchRequest<FavoriteEvent> = FavoriteEvent.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@ AND isFavorite == true", eventId)
        
        do {
            let events = try context.fetch(request)
            return !events.isEmpty
        } catch {
            print("❌ Ошибка проверки избранного: \(error.localizedDescription)")
            return false
        }
    }
    
    func isEventFavorite(eventDTO: EventDTO) -> Bool {
        return isEventFavorite(eventId: "\(eventDTO.id)")
    }
    
    func getFavoriteEvent(by eventId: String) -> FavoriteEvent? {
        let request: NSFetchRequest<FavoriteEvent> = FavoriteEvent.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@ AND isFavorite == true", eventId)
        
        do {
            let events = try context.fetch(request)
            return events.first
        } catch {
            print("❌ Ошибка поиска в избранном: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getCachedEvent(by eventId: String) -> FavoriteEvent? {
        let request: NSFetchRequest<FavoriteEvent> = FavoriteEvent.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@ AND isCached == true", eventId)
        
        do {
            let events = try context.fetch(request)
            return events.first
        } catch {
            print("❌ Ошибка поиска в кэше: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getAllFavoriteEvents() -> [FavoriteEvent] {
        let request: NSFetchRequest<FavoriteEvent> = FavoriteEvent.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == true")
        
        let sortDescriptor = NSSortDescriptor(key: "addedDate", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let favorites = try context.fetch(request)
            print("✅ Загружено избранных событий: \(favorites.count)")
            return favorites
        } catch {
            print("❌ Ошибка загрузки избранного: \(error.localizedDescription)")
            return []
        }
    }
    
    func getFavoritesCount() -> Int {
        let request: NSFetchRequest<FavoriteEvent> = FavoriteEvent.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == true")
        
        do {
            return try context.count(for: request)
        } catch {
            print("❌ Ошибка подсчета избранного: \(error.localizedDescription)")
            return 0
        }
    }
    
    func clearAllFavorites() {
        let request: NSFetchRequest<FavoriteEvent> = FavoriteEvent.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == true")
        
        do {
            let favorites = try context.fetch(request)
            for favorite in favorites {
                let isCached = favorite.value(forKey: "isCached") as? Bool ?? false
                
                if isCached {
                    favorite.setValue(false, forKey: "isFavorite")
                    favorite.setValue(nil, forKey: "addedDate")
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
    
    // MARK: - Вспомогательные методы
    
    private func deleteEventWithRelations(_ event: FavoriteEvent) {
        if let place = event.place {
            context.delete(place)
        }
        if let eventLocation = event.eventLocation {
            context.delete(eventLocation)
        }
        if let participants = event.participants {
            for case let participant as ParticipantEntity in participants {
                if let agent = participant.agent {
                    context.delete(agent)
                }
                context.delete(participant)
            }
        }
        if let images = event.images {
            for case let image as ImagesEntity in images {
                context.delete(image)
            }
        }
        context.delete(event)
    }
    
    func searchCachedEvents(searchText: String, cacheKey: String? = nil) -> [FavoriteEvent] {
        let request: NSFetchRequest<FavoriteEvent> = FavoriteEvent.fetchRequest()
        
        var predicates: [NSPredicate] = [NSPredicate(format: "isCached == true")]
        
        if let cacheKey = cacheKey {
            predicates.append(NSPredicate(format: "cacheKey == %@", cacheKey))
        }
        
        let searchPredicate = NSCompoundPredicate(
            orPredicateWithSubpredicates: [
                NSPredicate(format: "title CONTAINS[cd] %@", searchText),
                NSPredicate(format: "eventDescription CONTAINS[cd] %@", searchText),
                NSPredicate(format: "place.address CONTAINS[cd] %@", searchText),
                NSPredicate(format: "eventLocation.name CONTAINS[cd] %@", searchText)
            ]
        )
        
        predicates.append(searchPredicate)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        let sortDescriptor = NSSortDescriptor(key: "cachedDate", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try context.fetch(request)
        } catch {
            print("❌ Ошибка поиска: \(error.localizedDescription)")
            return []
        }
    }
}
