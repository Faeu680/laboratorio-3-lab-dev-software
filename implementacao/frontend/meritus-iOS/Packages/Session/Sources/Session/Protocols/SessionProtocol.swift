//
//  SessionProtocol.swift
//  Session
//
//  Created by Arthur Porto on 29/10/25.
//

import Foundation

public protocol SessionProtocol: Actor {
    func getActiveToken() -> String?
    nonisolated func getUnsafeActiveToken() -> String?
    
    func getUserId() -> String?
    nonisolated func unsafeGetUserId() -> String?
    
    func getName() -> String?
    nonisolated func unsafeGetName() -> String?
    
    func getEmail() -> String?
    nonisolated func unsafeGetEmail() -> String?
    
    func getRole() -> UserRole?
    nonisolated func unsafeGetRole() -> UserRole?
    
    func getAllSessions() -> [StoredSession]
    nonisolated func unsafeGetAllSessions() -> [StoredSession]
    
    func refresh(token: String) throws(SessionError)
    
    func switchToSession(_ userId: String) throws(SessionError)
    
    func isExpired() -> Bool
    
    func destroy()
}
