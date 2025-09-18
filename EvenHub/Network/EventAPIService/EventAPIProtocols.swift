//
//  EventAPIProtocols.swift
//  EvenHub
//
//  Created by Иван Семенов on 17.09.2025.
//

import Foundation

typealias IEventAPIService =
  IAPIServiceForExplore
& IAPIServiceForDetail
& IAPIServiceForSearch
& IAPIServiceForEvents
& IAPIServiceForMap

protocol IAPIServiceForExplore: IAPIServiceForDetail {
    ///fetch list of location
    func getLocations(with language: Language?) async throws -> [EventLocation]
    ///fetch list of category
    func getCategories(with language: Language?) async throws -> [CategoryDTO]
    func getTodayEvents(location: String, language: Language?, page: Int?) async throws -> [TodayEventDTO]
    func getMovies(location: String, language: Language?, page: Int?) async throws -> [MovieDTO]
    func getLists(location: String, language: Language?, page: Int?) async throws -> [ListDTO]
    ///fetches paginated list of upcoming events
    func getUpcomingEvents(with category: String?, _ language: Language, _ page: Int?) async throws -> [EventDTO]
    func getNearbyYouEvents(with language: Language?, _ location: String, _ category: String?, _ page: Int?) async throws -> [EventDTO]
}

protocol IAPIServiceForDetail {
    ///fetch details
    func getEventDetails(eventIDs: String, language: Language?) async throws -> [EventDTO]
}

protocol IAPIServiceForSearch {
    ///fetch for search text
    func getSearchedEvents(with searchText: String) async throws -> SearchResponseDTO
}

protocol IAPIServiceForEvents {
    ///fetch upcoming events
    func getUpcomingEvents(_ actualSince: String, _ actualUntil: String, _ language: Language, _ page: Int?) async throws -> [EventDTO]
    
    ///fetch past events
    func getPastEvents(_ actualUntil: String, _ language: Language, _ page: Int?) async throws -> [EventDTO]
}

protocol IAPIServiceForMap: IAPIServiceForSearch {
    ///list of event categories on the map
    func getCategories(with language: Language?) async throws -> [CategoryDTO]
    
    ///base on specified location and category
    func getEventsWith(location: String, _ category: String?, _ language: Language) async throws -> [EventDTO]
}
