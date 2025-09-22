//
//  ExploreViewModel.swift
//  EvenHub
//
//  Created by Andrei Kovryzhenko on 17.09.2025.
//

import UIKit

final class ExploreViewModel {
    static let shared = ExploreViewModel()
    
    //MARK: - Properties
    private let apiService = EventAPIService()
    lazy var dataManager = CoreDataManager.shared
    var locationsIsLoaded: ((EventLocation) -> Void)?
    var eventsIsLoaded: (() -> Void)?
    var nearbyIsLoaded: (() -> Void)?
    var currentLocationDidChange: (() -> Void)?
    private(set)var currentLocation: EventLocation? {
        didSet {
            currentLocationDidChange?()
        }
    }
    private(set)var category = CategoryType.allCases
    private(set)var locationPlaces = [EventLocation]() {
        didSet {
            setCurrentLocation(to: locationPlaces[0])
            locationsIsLoaded?(locationPlaces[0])
        }
    }
    private(set)var nearbyEvents = [FavoriteEvent]() {
        didSet {
            nearbyIsLoaded?()
        }
    }
    private(set)var upcomingEvents = [FavoriteEvent]() {
        didSet {
            eventsIsLoaded?()
        }
    }
    
    //MARK: - Lifecycle
    private init(){}
    
    //MARK: - Private methods
    private func fetchEventsById<T:Identifiable>(events: [T]) async -> [EventDTO] where T.ID == Int {
        var res = [EventDTO]()
        for event in events {
            do {
                let eventDto = try await apiService.getEventDetails(eventIDs: String(event.id), language: .en)
                res += eventDto
            } catch {
                print("ExploreViewModel: \(#function)\nОшибка: \(error.localizedDescription)")
            }
        }
        return res
    }
    private func saveAndReturnEvents(_ events: [EventDTO], key: String) -> [FavoriteEvent] {
        dataManager.cacheEvents(events, cacheKey: key)
        return dataManager.getCachedEvents(cacheKey: key)
    }
    private func saveEvents(_ events: [EventDTO], key: String) {
        dataManager.cacheEvents(events, cacheKey: key)
    }
    private func getTodayDate() -> String {
        let today = Date()

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: today)
    }
    
    //MARK: - Public methods
    func fetchLocations() async {
        do {
            let locationsResponse = try await apiService.getLocations(with: .en)
            locationPlaces = locationsResponse.compactMap {
                guard $0.name?.lowercased() != "interesting" && $0.slug.lowercased() != "nnv" else { return nil }
                return $0
            }
        }
        catch {
            print("ExploreViewModel: \(#function)\nОшибка: \(error.localizedDescription)")
        }
    }
    func fetchUpcomingEvents() async {
        do {
            let eventsResponse = try await apiService.getUpcomingEvents(with: .none, .en, .none)
            await MainActor.run {
                self.upcomingEvents = self.saveAndReturnEvents(eventsResponse, key: "upcomingEvents")
            }
        }
        catch {
            print("ExploreViewModel: \(#function)\nОшибка: \(error.localizedDescription)")
        }
    }
    func fetchNearby() async {
        let currentSlug = currentLocation?.slug != nil ? currentLocation!.slug : ""
        do {
            let eventsResponse = try await apiService.getNearbyYouEvents(with: .en, currentSlug, .none, .none)
            await MainActor.run {
                self.nearbyEvents = self.saveAndReturnEvents(eventsResponse, key: "nearbyEvents")
            }
        }
        catch {
            print("ExploreViewModel: \(#function)\nОшибка: \(error.localizedDescription)")
        }
    }
    func fetchPastEvents() async {
        let today = getTodayDate()
        do {
            let currentResponce = try await apiService.getUpcomingEvents("2025-01-01", today, .en, .none)
            await MainActor.run {
                self.saveEvents(currentResponce, key: "pastEvents")
            }
        }
        catch {
            print("ExploreViewModel: \(#function)\nОшибка: \(error.localizedDescription)")
        }
    }
    func addToFavorite(event: EventDTO) {
        dataManager.addToFavorites(from: event)
    }
    func setCurrentLocation(to place: EventLocation) {
        currentLocation = place
    }
    func checkDatabaseStatus() {
        dataManager.checkDatabaseStatus()
    }
}

enum CategoryType: CaseIterable {
    case sport
    case food
    case music
    case art
}

