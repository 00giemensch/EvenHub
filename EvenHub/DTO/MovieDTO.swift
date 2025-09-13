//
//  MovieDTO.swift
//  EvenHub
//
//  Created by Иван Семенов on 11.09.2025.
//

import Foundation

struct MoviesResponseDTO: Codable, Sendable {
    let results: [MovieDTO]
}

struct MovieDTO: Codable, Identifiable, Sendable {
    let id: Int
    let siteURL: String
    let title: String
    let year: Int
    let poster: Poster
}

struct Poster: Codable, Sendable {
    let image: String
}
