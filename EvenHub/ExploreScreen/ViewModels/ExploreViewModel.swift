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
    var locationsIsLoaded: (([String]) -> Void)?
    var eventsIsLoaded: (() -> Void)?
    private(set)var category = CategoryType.allCases
    private(set)var locationPlaces = [String]() {
        didSet {
            locationsIsLoaded?(locationPlaces)
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
                return $0.name
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
}

enum CategoryType: CaseIterable {
    case sport
    case food
    case music
    case art
}

