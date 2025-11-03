//
//  NetworkResponseInfo.swift
//  Networking
//
//  Created by Arthur Porto on 02/11/25.
//

public struct NetworkResponseInfo: Codable, Sendable {
    public let statusCode: Int?
    public let headers: [String: String]
    public let body: String?
    public let errorDescription: String?
}
