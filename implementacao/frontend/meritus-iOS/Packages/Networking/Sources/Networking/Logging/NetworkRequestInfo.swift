//
//  NetworkRequestInfo.swift
//  Networking
//
//  Created by Arthur Porto on 02/11/25.
//

public struct NetworkRequestInfo: Codable, Sendable {
    public let method: String
    public let url: String
    public let headers: [String: String]
    public let body: String?
    public let curl: String?
}
