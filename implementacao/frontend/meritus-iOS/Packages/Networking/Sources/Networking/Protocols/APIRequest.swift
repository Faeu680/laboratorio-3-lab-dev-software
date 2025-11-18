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
    var usePathAsURL: Bool { get }
    var path: String { get }
    var contentType: ContentType { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: BodyType { get }
    var timeout: TimeInterval { get }
}

public extension APIRequest {
    var usePathAsURL: Bool { false }
    var contentType: ContentType { .json }
    var headers: [String: String]? { nil }
    var queryItems: [URLQueryItem]? { nil }
    var body: BodyType { .none }
    var timeout: TimeInterval { 30 }
    
    func asURLRequest() throws -> URLRequest {
        let absolutePath = "https://meritus.bitpickle.dev/api"
        let completePath: String
        
        if !usePathAsURL {
            completePath = absolutePath + path
        } else {
            completePath = path
        }
        
        guard var urlComponents = URLComponents(string: completePath) else {
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
        
        switch body {
        case .none:
            break
        case let .json(encodable):
            do {
                request.httpBody = try JSONEncoder().encode(encodable)
                request.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
            } catch {
                throw NetworkError.encodingError(error)
            }
        case let .data(data):
            request.httpBody = data
        }
        
        return request
    }
}
