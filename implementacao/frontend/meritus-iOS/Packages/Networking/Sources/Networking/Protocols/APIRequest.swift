//
//  APIRequest.swift
//  Networking
//
//  Created by Arthur Porto on 17/10/25.
//

import Foundation

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
}
