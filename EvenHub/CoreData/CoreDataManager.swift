//
//  CoreDataManager.swift
//  EvenHub
//
//  Created by Евгений Васильев on 17.09.2025.
//
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
    
    // MARK: - Favorite Operations
    func addToFavorites(from eventDTO: EventDTO) -> Bool {
        if isEventFavorite(eventId: "\(eventDTO.id)") {
            print("⚠️ Событие уже в избранном: \(eventDTO.title)")
            return false
        }
        let favoriteEvent = FavoriteEvent(context: context)
        favoriteEvent.id = "\(eventDTO.id)"
        favoriteEvent.title = eventDTO.title
        favoriteEvent.eventDescription = eventDTO.description
        favoriteEvent.bodyText = eventDTO.bodyText
        favoriteEvent.favoritesCount = Int32(eventDTO.favoritesCount ?? 0)
        if let firstDate = eventDTO.dates.first {
            favoriteEvent.startDate = firstDate.startDate
            favoriteEvent.startTime = firstDate.startTime
            favoriteEvent.endTime = firstDate.endTime
        }
        if let place = eventDTO.place {
            favoriteEvent.placeTitle = place.title
            favoriteEvent.placeAdress = place.address
            favoriteEvent.placeSlug = place.slug
            favoriteEvent.latitude = place.coords.lat
            favoriteEvent.longitude = place.coords.lon
        }
        if let location = eventDTO.location {
            favoriteEvent.locationSlug = location.slug
            favoriteEvent.locationName = location.name
        }
        if let firstImage = eventDTO.images.first?.image {
            favoriteEvent.imageURL = firstImage
        }
        if let participants = eventDTO.participants {
            favoriteEvent.participantsJSON = participantsToJSONString(participants)
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
        context.delete(favoriteEvent)
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
    
    func isEventFavorite(eventId: String) -> Bool {
        return getFavoriteEvent(by: eventId) != nil
    }
    
    func isEventFavorite(eventDTO: EventDTO) -> Bool {
        return isEventFavorite(eventId: "\(eventDTO.id)")
    }
    
    func getFavoriteEvent(by eventId: String) -> FavoriteEvent? {
        let request: NSFetchRequest<FavoriteEvent> = FavoriteEvent.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", eventId)
        
        do {
            let events = try context.fetch(request)
            return events.first
        } catch {
            print("❌ Ошибка поиска в избранном: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getAllFavoriteEvents() -> [FavoriteEvent] {
        let request: NSFetchRequest<FavoriteEvent> = FavoriteEvent.fetchRequest()
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
        
    // MARK: - Вспомогательные методы
    
    private func participantsToJSONString(_ participants: [Participant]) -> String? {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(participants)
            return String(data: data, encoding: .utf8)
        } catch {
            print("❌ Ошибка конвертации участников в JSON: \(error)")
            return nil
        }
    }
    
    func getParticipants(from favoriteEvent: FavoriteEvent) -> [Participant]? {
        guard let jsonString = favoriteEvent.participantsJSON,
              let data = jsonString.data(using: .utf8) else {
            return nil
        }
        let decoder = JSONDecoder()
        do {
            return try decoder.decode([Participant].self, from: data)
        } catch {
            print("❌ Ошибка декодирования участников: \(error)")
            return nil
        }
    }
    
    func getCoordinates(from favoriteEvent: FavoriteEvent) -> Coordinates? {
        guard favoriteEvent.latitude != 0, favoriteEvent.longitude != 0 else {
            return nil
        }
        return Coordinates(lat: favoriteEvent.latitude, lon: favoriteEvent.longitude)
    }
    
    func getFavoritesCount() -> Int {
        let request: NSFetchRequest<FavoriteEvent> = FavoriteEvent.fetchRequest()
        
        do {
            return try context.count(for: request)
        } catch {
            print("❌ Ошибка подсчета избранного: \(error.localizedDescription)")
            return 0
        }
    }
    
    func clearAllFavorites() {
        let request: NSFetchRequest<NSFetchRequestResult> = FavoriteEvent.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(deleteRequest)
            saveContext()
            print("✅ Все избранные события удалены")
        } catch {
            print("❌ Ошибка удаления избранного: \(error.localizedDescription)")
        }
    }
}
