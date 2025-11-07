//
//  ServiceError.swift
//  Domain
//
//  Created by Arthur Porto on 29/10/25.
//

public enum ServiceError: Error, Equatable, Sendable {
    case invalidURL
    case invalidResponse
    case unauthorized(message: String?)
    case forbidden(message: String?)
    case notFound(message: String?)
    case serverError(Int, message: String?)
    case noData
    case noInternetConnection
}
