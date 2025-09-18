//
//  APIClient.swift
//  EvenHub
//
//  Created by Иван Семенов on 17.09.2025.
//

import Foundation

protocol APISpec {
    var path: APIPath { get }
    var method: HttpMethod { get }
    var queryItems: [URLQueryItem] { get }
    var body: Data? { get }
    var cachePolicy: URLRequest.CachePolicy { get }
}

struct APIConfig {
    static let scheme = "https"
    static let host = "kudago.com"
    static let basePath = "/public-api/v1.4"
}

enum APIPath: String {
    case events
    case movies
    case lists
    case search
    case locations
    case eventCategories = "event-categories"
    
    func fullPath() -> String {
        return APIConfig.basePath + "/" + rawValue
    }
    
    func url(with queryItems: [URLQueryItem] = []) -> URL? {
        var components = URLComponents()
        components.scheme = APIConfig.scheme
        components.host = APIConfig.host
        components.path = fullPath()
        components.queryItems = queryItems.isEmpty ? nil : queryItems
        return components.url
    }
}

enum HttpMethod: String {
    case get, patch, post, delete
    var desc: String { rawValue.uppercased() }
}

protocol APIClientProtocol {
    func sendRequest<T: Decodable>(_ spec:  APISpec, responseType: T.Type) async throws -> T
}

// MARK: - API Client
struct APIClient: APIClientProtocol {
    private let session: URLSession
    private let jsonDecoder: JSONDecoder
    private let cache = URLCache(
        memoryCapacity: 10 * 1024 * 1024,
        diskCapacity: 50 * 1024 * 1024,
        diskPath: "api_cache"
    )
    
    init(session: URLSession = .shared) {
        self.session = session
        URLCache.shared = cache
        self.jsonDecoder = JSONDecoder()
        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func sendRequest<T: Decodable>(
        _ spec:  APISpec,
        responseType: T.Type
    ) async throws -> T {
        
        guard let url = spec.path.url(with: spec.queryItems) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(
            url: url,
            cachePolicy: spec.cachePolicy,
            timeoutInterval: 30.0
        )
        request.httpMethod = spec.method.desc
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let body = spec.body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = body
        }
        
        let (data, response) = try await session.data(for: request)
        try validateResponse(response)
        return try jsonDecoder.decode(T.self, from: data)
    }
    
    private func validateResponse(_ response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse else { throw NetworkError.invalidResponse }
        
        switch http.statusCode {
        case 200...299: return
        case 400: throw NetworkError.serverError(statusCode: http.statusCode, description: "bad request")
        case 401: throw NetworkError.serverError(statusCode: http.statusCode, description: "unauthorised")
        case 403: throw NetworkError.serverError(statusCode: http.statusCode, description: "forbidden")
        case 404: throw NetworkError.serverError(statusCode: http.statusCode, description: "not found")
        case 500...599: throw NetworkError.serverError(statusCode: http.statusCode, description: "server error")
        default: throw NetworkError.serverError(statusCode: http.statusCode, description: "unhandled error")
        }
    }
}
