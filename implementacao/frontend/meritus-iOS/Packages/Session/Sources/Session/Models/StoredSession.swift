//
//  StoredSession.swift
//  Session
//
//  Created by Arthur Porto on 21/11/25.
//

import Foundation

public struct StoredSession: Codable, Sendable, Equatable, Hashable {
    internal let token: String
    internal let expiration: Date
    
    public let userId: String
    public let name: String
    public let email: String
    public let role: UserRole
    public let isActive: Bool
}
