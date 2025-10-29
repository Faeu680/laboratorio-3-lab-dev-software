//
//  APIErrorResponse.swift
//  Networking
//
//  Created by Arthur Porto on 29/10/25.
//

public struct APIErrorResponse: Decodable, Sendable {
    public let data: ErrorData
    
    public struct ErrorData: Decodable, Sendable {
        public let statusCode: Int
        public let timestamp: String
        public let path: String
        public let message: String
    }
}
