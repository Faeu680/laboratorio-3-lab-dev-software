//
//  APIRequest.swift
//  Networking
//
//  Created by Arthur Porto on 17/10/25.
//

import Foundation
import Commons

fileprivate let keychainManager = KeychainManager.shared

public protocol APIRequest: Sendable {
    var scope: APIScope { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Encodable? { get }
    var timeout: TimeInterval { get }
}

public extension APIRequest {
    var headers: [String: String]? { nil }
    var queryItems: [URLQueryItem]? { nil }
    var body: Encodable? { nil }
    var timeout: TimeInterval { 30 }
    
    func asURLRequest() throws -> URLRequest {
        guard var urlComponents = URLComponents(string: "https://meritus.bitpickle.dev/api" + path) else {
            throw NetworkError.invalidURL
        }
        
        if let queryItems = queryItems {
            urlComponents.queryItems = queryItems
        }
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = timeout
        
        var finalHeaders = headers ?? [:]
        
        if case .authenticated = scope {
            if let token = try? keychainManager.read(for: .authToken) {
                finalHeaders["Authorization"] = "Bearer \(token)"
            }
        }
        
        finalHeaders.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        if let body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                throw NetworkError.encodingError(error)
            }
        }
        
        return request
    }
}
