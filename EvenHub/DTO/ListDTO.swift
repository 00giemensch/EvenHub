//
//  ListDTO.swift
//  EvenHub
//
//  Created by Иван Семенов on 11.09.2025.
//

import Foundation

struct ResponseListDTO:  Codable, Sendable {
    let results: [ListDTO]
}

struct ListDTO: Codable, Identifiable, Sendable {
    let id: Int
    let publicationDate: Date
    let title: String
    let slug: String
    let siteURL: String
}
