//
//  SearchEventDTO.swift
//  EvenHub
//
//  Created by Иван Семенов on 11.09.2025.
//

import Foundation

struct SearchResponseDTO: Codable, Sendable {
    let results: [SearchResultDTO]
}

struct SearchResultDTO: Codable, Identifiable, Sendable {
    let id: Int
    let slug, title: String
    let description: String
    let itemURL: String?
    let place: Place?
    let daterange: Daterange?
    let firstImage: FirstImage?
}

struct Daterange: Codable, Sendable {
    let start: Int?
    let end: Int?
    let startDate: Int?
    let startTime: Int?
    let endTime: Int?
}

struct FirstImage: Codable, Sendable {
    let image: String
}

struct Place: Codable, Identifiable, Sendable {
    let id: Int
    let title, slug, address: String
    let coords: Coords
    let location: String
}

struct Coords: Codable, Sendable {
    let lat, lon: Double
}
