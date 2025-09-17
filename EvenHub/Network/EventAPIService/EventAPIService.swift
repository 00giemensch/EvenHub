//
//  EventAPIService.swift
//  EvenHub
//
//  Created by Иван Семенов on 17.09.2025.
//

import Foundation

//MARK: Adapter
final class EventAPIService: IEventAPIService {
    
    let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }
    
    // MARK: - Locations
    func getLocations(with language: Language?) async throws -> [EventLocation] {
        let spec: EventAPISpec = .getLocation(language: language)
        return try await apiClient.sendRequest(spec, responseType: [EventLocation].self)
    }
    
    // MARK: - Categories
    func getCategories(with language: Language?) async throws -> [CategoryDTO] {
        let spec: EventAPISpec = .getCategories(language: language)
        return try await apiClient.sendRequest(spec, responseType: [CategoryDTO].self)
    }
    
    // MARK: - Events (lists)
    func getTodayEvents(location: String, language: Language?, page: Int?) async throws -> [TodayEventDTO] {
        let spec: EventAPISpec = .getTodayEvents(location: location, language: language, page: page)
        let response = try await apiClient.sendRequest(spec, responseType: TodayEventsDTO.self)
        return response.results
    }
    
    func getMovies(location: String, language: Language?, page: Int?) async throws -> [MovieDTO] {
        let spec: EventAPISpec = .getMovies(location: location, language: language, page: page)
        let response = try await apiClient.sendRequest(spec, responseType: MoviesResponseDTO.self)
        return response.results
    }
    
    func getLists(location: String, language: Language?, page: Int?) async throws -> [ListDTO] {
        let spec: EventAPISpec = .getLists(location: location, language: language, page: page)
        return try await apiClient.sendRequest(spec, responseType: [ListDTO].self)
    }
    
    // MARK: - Events (catalog)
    func getUpcomingEvents(with category: String?, _ language: Language, _ page: Int?) async throws -> [EventDTO] {
        let spec: EventAPISpec = .getUpcomingEventsWith(category: category, language: language, page: page)
        let response: APIResponseDTO = try await apiClient.sendRequest(spec, responseType: APIResponseDTO.self)
        return response.results
    }
    
    func getNearbyYouEvents(with language: Language?, _ location: String, _ category: String?, _ page: Int?) async throws -> [EventDTO] {
        let spec: EventAPISpec = .getNearbyYouEvents(language: language, location: location, category: category, page: page)
        let response: APIResponseDTO = try await apiClient.sendRequest(spec, responseType: APIResponseDTO.self)
        return response.results
    }
    
    // MARK: - Details
    func getEventDetails(eventIDs: String, language: Language?) async throws -> [EventDTO] {
        let spec: EventAPISpec = .getEventDetails(eventIDs: eventIDs, language: language)
        let response: APIResponseDTO = try await apiClient.sendRequest(spec, responseType: APIResponseDTO.self)
        return response.results
    }
    
    // MARK: - Search
    func getSearchedEvents(with searchText: String) async throws -> SearchResponseDTO {
        let spec: EventAPISpec = .getSearchedEventsWith(searchText: searchText)
        return try await apiClient.sendRequest(spec, responseType: SearchResponseDTO.self)
    }
    
    // MARK: - Ranged events (upcoming/past)
    func getUpcomingEvents(_ actualSince: String, _ actualUntil: String, _ language: Language, _ page: Int?) async throws -> [EventDTO] {
        let spec: EventAPISpec = .getUpcomingEvents(actualSince: actualSince, actualUntil: actualUntil, language: language, page: page)
        let response: APIResponseDTO = try await apiClient.sendRequest(spec, responseType: APIResponseDTO.self)
        return response.results
    }
    
    func getPastEvents(_ actualUntil: String, _ language: Language, _ page: Int?) async throws -> [EventDTO] {
        let spec: EventAPISpec = .getPastEvents(actualUntil: actualUntil, language: language, page: page)
        let response: APIResponseDTO = try await apiClient.sendRequest(spec, responseType: APIResponseDTO.self)
        return response.results
    }
    
    // MARK: - Map
    func getEventsWith(location: String, _ category: String?, _ language: Language) async throws -> [EventDTO] {
        let spec: EventAPISpec = .getEventsForMap(coordinate: location, category: category, language: language)
        return try await apiClient.sendRequest(spec, responseType: APIResponseDTO.self).results
    }
}
