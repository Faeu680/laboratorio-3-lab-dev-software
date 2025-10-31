//
//  SessionProtocol.swift
//  Session
//
//  Created by Arthur Porto on 29/10/25.
//

public protocol SessionProtocol: Actor {
    func getUserId() -> String?
    
    func getEmail() -> String?
    
    func getRole() -> UserRole?
    
    func refresh(token: String) throws(SessionError)
    
    func isExpired() -> Bool
    
    func destroy()
}
