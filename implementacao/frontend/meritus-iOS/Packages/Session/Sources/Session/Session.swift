//
//  Session.swift
//  Session
//
//  Created by Arthur Porto on 29/10/25.
//

import Foundation

final actor Session: SessionProtocol {
    private var userId: String?
    private var email: String?
    private var role: UserRole?
    
    func getUserId() -> String? {
        userId
    }
    
    func getEmail() -> String? {
        email
    }
    
    func getRole() -> UserRole? {
        role
    }
    
    func refresh(token: String) throws(SessionError) {
        let payload = try Self.decodeToken(token)
        
        guard let userId = payload["sub"] as? String,
              let email = payload["email"] as? String,
              let roleString = payload["role"] as? String,
              let role = UserRole(rawValue: roleString)  else {
            throw .missingField
        }
        
        self.userId = userId
        self.email = email
        self.role = role
    }
    
    func destroy() {
        self.userId = nil
        self.email = nil
        self.role = nil
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
