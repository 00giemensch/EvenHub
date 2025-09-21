//
//  SearchViewModel.swift
//  EvenHub
//
//  Created by Andrei Kovryzhenko on 21.09.2025.
//

import UIKit

class SearchViewModel {
    static let shared = SearchViewModel()
    
    //MARK: - Properties
    private let key = "searchEvent"
    var searchedEventsLoaded: (() -> Void)?
    private lazy var dataManager = CoreDataManager.shared
    private let apiService = EventAPIService()
    private(set) var searchedEvents = [FavoriteEvent]() {
        didSet {
            filtredEvents = searchedEvents
        }
    }
    private(set)var filtredEvents = [FavoriteEvent]() {
        didSet {
            searchedEventsLoaded?()
        }
    }
    
    //MARK: - Lifecycle
    private init(){}
    
    //MARK: - Private methods
    private func fetchEventsById(searchResult: [SearchResultDTO]) async -> [EventDTO] {
        var res = [EventDTO]()
        for searchEvent in searchResult {
            do {
                let event = try await apiService.getEventDetails(eventIDs: String(searchEvent.id), language: .en)
                res += event
            } catch {
                print("ExploreViewModel: \(#function)\nОшибка: \(error.localizedDescription)")
            }
        }
        return res
    }
    private func saveEventsToCoreData(_ events: [EventDTO]) {
        dataManager.cacheEvents(events, cacheKey: key)
        searchedEvents = dataManager.getCachedEvents(cacheKey: key)
    }
    //MARK: - Public methods
    func searchEvent(with searchText: String) async {
        do {
            let eventsResponse = try await apiService.getSearchedEvents(with: searchText)
            let events = await fetchEventsById(searchResult: eventsResponse.results)
            await MainActor.run {
                self.saveEventsToCoreData(events)
            }
        }
        catch {
            print("ExploreViewModel: \(#function)\nОшибка: \(error.localizedDescription)")
        }
    }
    func checkStorage() {
        dataManager.checkDatabaseStatus()
    }
    func clearSavedEvents() {
        dataManager.clearCachedEvents(cacheKey: key)
    }
    func filterByCategory(category: String?) {
        
    }
}
