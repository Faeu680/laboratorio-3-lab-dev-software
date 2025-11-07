//
//  SessionProtocol.swift
//  Session
//
//  Created by Arthur Porto on 29/10/25.
//

public protocol SessionProtocol: Actor {
    func getUserId() -> String?
    nonisolated func unsafeGetUserId() -> String?
    
    func getEmail() -> String?
    nonisolated func unsafeGetEmail() -> String?
    
    func getRole() -> UserRole?
    nonisolated func unsafeGetRole() -> UserRole?
    
    func refresh(token: String) throws(SessionError)
    
    func isExpired() -> Bool
    
    func destroy()
}
