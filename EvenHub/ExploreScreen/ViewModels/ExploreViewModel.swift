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
    private(set)var nearbyEvents = [EventDTO]() {
        didSet {
            nearbyIsLoaded?()
        }
    }
    private(set)var upcomingEvents = [EventDTO]() {
        didSet {
            eventsIsLoaded?()
        }
    }
    
    //MARK: - Lifecycle
    private init(){}
  
    //MARK: - Private methods
    func fetchLocations() async {
        do {
            let locationsResponse = try await apiService.getLocations(with: .en)
            locationPlaces = locationsResponse.compactMap {
                guard $0.name?.lowercased() != "interesting" else { return nil }
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
            upcomingEvents = eventsResponse
        }
        catch {
            print("ExploreViewModel: \(#function)\nОшибка: \(error.localizedDescription)")
        }
    }
    func fetchNearby() async {
        guard let currentSlug = currentLocation?.slug else { return }
        do {
            let eventsResponse = try await apiService.getNearbyYouEvents(with: .en, currentSlug, .none, .none)
            nearbyEvents = eventsResponse
        }
        catch {
            print("ExploreViewModel: \(#function)\nОшибка: \(error.localizedDescription)")
        }
    }
    
    func setCurrentLocation(to place: EventLocation) {
        currentLocation = place
    }
}

enum CategoryType: CaseIterable {
    case sport
    case food
    case music
    case art
}

