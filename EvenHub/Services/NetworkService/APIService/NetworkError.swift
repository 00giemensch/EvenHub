//
//  NetworkError.swift
//  EvenHub
//
//  Created by Иван Семенов on 11.09.2025.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int, description: String)
    case dataConversionFailure
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "the url is invalid"
        case .invalidResponse:
            return "the response is invalid"
        case .serverError(let statusCode, let description):
            return "status code: \(statusCode), description \(description)"
        case .dataConversionFailure:
            return "failure to decode"
        }
    }
}
