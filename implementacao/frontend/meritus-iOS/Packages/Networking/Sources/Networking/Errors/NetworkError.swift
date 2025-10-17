//
//  NetworkError.swift
//  Networking
//
//  Created by Arthur Porto on 17/10/25.
//

import Foundation

public enum NetworkError: LocalizedError, Sendable {
    case invalidURL
    case invalidResponse
    case unauthorized
    case forbidden
    case notFound
    case serverError(Int)
    case noData
    case noInternetConnection
    case decodingError(Error)
    case encodingError(Error)
    case networkError(Error)
    case unknown
}
