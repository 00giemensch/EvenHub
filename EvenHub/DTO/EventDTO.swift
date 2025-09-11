//
//  EventDTO.swift
//  EvenHub
//
//  Created by Иван Семенов on 11.09.2025.
//

import Foundation
import CoreLocation

struct APIResponseDTO: Codable, Sendable {
    let results: [EventDTO]
}

struct EventDTO: Codable, Identifiable, Sendable {
    let id: Int
    let title: String
    let images: [ImageDTO]
    let description: String?
    let bodyText: String?
    let favoritesCount: Int?
    let dates: [EventDate]
    let place: PlaceDTO?
    let location: EventLocation?
    let participants: [Participant]?
}

struct CategoryDTO: Codable, Identifiable, Sendable {
    let id: Int
    let slug: String
    let name: String
}

struct EventDate: Codable, Sendable {
    let start:Int?
    let end: Int?
    let startDate: String?
    let startTime: String?
    let endTime: String?
}

struct PlaceDTO: Codable, Sendable {
    let id: Int
    let title: String?
    let slug: String
    let address: String
    let coords: Coordinates
    let location: String
}

struct Coordinates: Codable, Sendable {
    let lat: Double
    let lon: Double
    var toCLLocationCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}

struct EventLocation: Codable, Sendable {
    let slug: String
    let name: String?
}

struct Participant: Codable, Sendable {
    let role: Role?
    let agent: Agent?
}

struct Role: Codable, Sendable {
    let slug: String?
}

struct Agent: Codable, Sendable {
    let id: Int
    let title: String?
    let images: [ImageDTO]?
}

enum Language: String, Codable {
    case ru, en
}

struct ImageDTO: Codable, Sendable {
    let image: String?
}
