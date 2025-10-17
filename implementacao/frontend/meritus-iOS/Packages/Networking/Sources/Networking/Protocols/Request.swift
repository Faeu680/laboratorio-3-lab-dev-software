//
//  Request.swift
//  Networking
//
//  Created by Arthur Porto on 17/10/25.
//

import Foundation

public protocol Request: Sendable {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Encodable? { get }
    var timeout: TimeInterval { get }
}

public extension Request {
    var baseURL: String { "" }
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
        
        if let headers = headers {
            headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        }
        
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
