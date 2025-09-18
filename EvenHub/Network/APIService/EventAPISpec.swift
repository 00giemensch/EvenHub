//
//  EventAPISpec.swift
//  EvenHub
//
//  Created by Иван Семенов on 17.09.2025.
//

import Foundation

extension EventAPISpec: APISpec {
    var path: APIPath {
        switch self {
        case .getLocation: return .locations
        case .getSearchedEventsWith: return .search
        case .getCategories: return .eventCategories
        case .getTodayEvents, .getUpcomingEventsWith, .getNearbyYouEvents, .getPastEvents, .getUpcomingEvents, .getEventsForMap:
            return .events
        case .getMovies: return .movies
        case .getLists: return .lists
        case .getEventDetails: return .events
        }
    }
    
    var method: HttpMethod { .get }
    var body: Data? { nil }
    var cachePolicy: URLRequest.CachePolicy { .useProtocolCachePolicy }
}

enum EventAPISpec {
    case getLocation(language: Language?)
    case getSearchedEventsWith(searchText: String)
    case getCategories(language: Language?)
    case getUpcomingEventsWith(
        category: String?,
        language: Language?,
        page: Int?
    )
    case getTodayEvents(
        location: String,
        language: Language?,
        page: Int?
    )
    case getMovies(
        location: String,
        language: Language?,
        page: Int?
    )
    case getLists(
        location: String,
        language: Language?,
        page: Int?
    )
    case getNearbyYouEvents(
        language: Language?,
        location: String,
        category: String?,
        page: Int?
    )
    case getUpcomingEvents(
        actualSince: String,
        actualUntil: String,
        language: Language?,
        page: Int?
    )
    case getPastEvents(
        actualUntil: String,
        language: Language?,
        page: Int?
    )
    case getEventDetails(
        eventIDs: String,
        language: Language?
    )
    case getEventsForMap(
        coordinate: String,
        category: String?,
        language: Language?
    )
    // MARK: - helper methods
    /// returns common query items such as language and page
    private func commonQueryItems(language: Language?, page: Int?) -> [URLQueryItem] {
        var items: [URLQueryItem] = []
        if let language = language {
            items.append(URLQueryItem(name: "lang", value: language.rawValue))
        }
        if let page = page {
            items.append(URLQueryItem(name: "page", value: "\(page)"))
        }
        return items
    }
    
    /// returns common event fields and parameters
    private var commonEventFields: [URLQueryItem] {
        return [
            URLQueryItem(name: "page_size", value: "30"),
            URLQueryItem(name: "expand", value: "location,place,dates,participants"),
            URLQueryItem(name: "fields", value: "id,title,description,body_text,favorites_count,place,location,dates,participants,images,site_url")
        ]
    }
    
    /// returns query items specific to each case.
    var queryItems: [URLQueryItem] {
        switch self {
        case .getLocation(let language),
             .getCategories(let language):
            return commonQueryItems(language: language, page: nil)
            
        case .getTodayEvents(let location, let language, let page):
            return [
                URLQueryItem(name: "location", value: location)
            ] + commonQueryItems(language: language, page: page)
            
        case .getMovies(let location, let language, let page),
             .getLists(let location, let language, let page):
            return [
                URLQueryItem(name: "location", value: location),
                URLQueryItem(name: "actual_since", value: Date.now.ISO8601Format())
            ] + commonQueryItems(language: language, page: page) + [
                URLQueryItem(name: "fields", value: "id,title,year,poster,site_url")
            ]
            
        case .getUpcomingEventsWith(let category, let language, let page):
            var items = commonEventFields
            if let category = category {
                items.append(URLQueryItem(name: "categories", value: category))
            }
            return items + commonQueryItems(language: language, page: page)
            
        case .getNearbyYouEvents(let language, let location, let category, let page):
            var items = commonEventFields
            items.append(URLQueryItem(name: "location", value: location))
            if let category = category {
                items.append(URLQueryItem(name: "categories", value: category))
            }
            return items + commonQueryItems(language: language, page: page)
        
        case .getUpcomingEvents(let actualSince, let actualUntil, let language, let page):
            return [
                URLQueryItem(name: "actual_since", value: actualSince),
                URLQueryItem(name: "actual_until", value: actualUntil)
            ] + commonEventFields + commonQueryItems(language: language, page: page)
            
        case  .getPastEvents(let actualUntil, let language, let page):
            return [
                URLQueryItem(name: "actual_until", value: actualUntil)
            ] + commonEventFields + commonQueryItems(language: language, page: page)
            
        case .getEventDetails(eventIDs: let eventIDs, language: let language):
            return [
                URLQueryItem(name: "ids", value: eventIDs),
                URLQueryItem(name: "expand", value: "location,place,dates,participants"),
                URLQueryItem(name: "fields", value: "id,title,description,body_text,favorites_count,place,location,dates,participants,categories,images" )
            ] + commonQueryItems(language: language, page: nil)
            
        case .getSearchedEventsWith(let searchText):
            return [
                URLQueryItem(name: "q", value: searchText),
                URLQueryItem(name: "page_size", value: "50"),
                URLQueryItem(name: "actual_since", value: Date.now.ISO8601Format())
            ] + commonEventFields
            
        case .getEventsForMap(let coordinate, let category, let language):
            var items: [URLQueryItem] = [
                URLQueryItem(name: "location", value: coordinate),
                URLQueryItem(name: "order_by", value: "-dates")
            ] + commonEventFields
            if let category = category {
                items.append(URLQueryItem(name: "categories", value: category))
            }
            return items + commonQueryItems(language: language, page: nil)
        }
    }
}
