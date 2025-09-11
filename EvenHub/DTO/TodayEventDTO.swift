//
//  TodayEventDTO.swift
//  EvenHub
//
//  Created by Иван Семенов on 11.09.2025.
//

import Foundation

struct TodayEventsDTO: Codable, Sendable {
    let results: [TodayEventDTO]
}

struct TodayEventDTO: Codable, Sendable {
    let date, location: String
    let object: Object
    let title: String
}

struct Object: Codable, Sendable {
    let id: Int
    let ctype: String
}
