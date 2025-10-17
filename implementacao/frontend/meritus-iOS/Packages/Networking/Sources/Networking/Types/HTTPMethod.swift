//
//  HTTPMethod.swift
//  Networking
//
//  Created by Arthur Porto on 17/10/25.
//

public enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
