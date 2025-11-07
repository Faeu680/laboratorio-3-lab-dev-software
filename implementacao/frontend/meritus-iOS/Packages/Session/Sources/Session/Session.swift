//
//  Session.swift
//  Session
//
//  Created by Arthur Porto on 29/10/25.
//

import Foundation
import Commons

final actor Session: SessionProtocol {
    private let keychain = KeychainManager.shared
    private nonisolated(unsafe) var userId: String?
    private nonisolated(unsafe) var email: String?
    private nonisolated(unsafe) var role: UserRole?
    private nonisolated(unsafe) var expiration: Date?
    
    init() {
        guard let token = try? keychain.read(for: .authToken) else {
            return
        }
        
        Task(priority: .userInitiated) {
            try? await refresh(token: token)
        }
    }
    
    func getUserId() -> String? {
        userId
    }
    
    nonisolated func unsafeGetUserId() -> String? {
        userId
    }
    
    func getEmail() -> String? {
        email
    }
    
    nonisolated func unsafeGetEmail() -> String? {
        email
    }
    
    func getRole() -> UserRole? {
        role
    }
    
    nonisolated func unsafeGetRole() -> UserRole? {
        role
    }
    
    func refresh(token: String) throws(SessionError) {
        let payload = try Self.decodeToken(token)
        
        guard let userId = payload["sub"] as? String,
              let email = payload["email"] as? String,
              let role = payload["role"] as? String,
              let expiration = payload["exp"] as? TimeInterval else {
            throw .missingField
        }
        
        self.userId = userId
        self.email = email
        self.role = UserRole(rawValue: role)
        self.expiration = Date(timeIntervalSince1970: expiration)
        
        do {
            try keychain.save(token, for: .authToken)
        } catch {
            throw .keychainError
        }
    }
    
    func destroy() {
        self.userId = nil
        self.email = nil
        self.role = nil
        self.expiration = nil
        
        try? keychain.delete(for: .authToken)
    }
    
    func isExpired() -> Bool {
        guard let expiration = expiration else {
            return true
        }
        
        let isExpired = Date() >= expiration
        if isExpired {
            destroy()
        }
        
        return isExpired
    }
    
    private static func decodeToken(_ token: String) throws(SessionError) -> [String: Any] {
        let parts = token.components(separatedBy: ".")
        
        guard parts.count == 3 else {
            throw .invalidToken
        }
        
        let payloadEncoded = parts[1]
        
        return try decodeBase64(encodedString: payloadEncoded)
    }
    
    private static func decodeBase64(encodedString: String) throws(SessionError) -> [String: Any] {
        var base64 = encodedString
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        let padding = 4 - (base64.count % 4)
        if padding != 4 {
            base64 += String(repeating: "=", count: padding)
        }
        
        guard let data = Data(base64Encoded: base64) else {
            throw .decodingError
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            throw SessionError.decodingError
        }
        
        return json
    }
}
