//
//  Session.swift
//  Session
//
//  Created by Arthur Porto on 29/10/25.
//

import Foundation
import Commons

final actor Session: SessionProtocol {

    // MARK: - Private Properties

    private let keychain = KeychainManager.shared
    private nonisolated(unsafe) var sessions: [String: StoredSession] = [:]
    private nonisolated(unsafe) var activeUserId: String?

    // MARK: - Init

    init() {
        Task(priority: .userInitiated) {
            await self.loadAllSessions()
            await self.loadActiveSession()
        }
    }

    // MARK: - Public Methods
    
    func getActiveToken() -> String? {
        guard let userId = activeUserId,
              let token = sessions[userId]?.token
        else { return nil }
        
        return token
    }
    
    nonisolated func getUnsafeActiveToken() -> String? {
        guard let userId = activeUserId,
              let token = sessions[userId]?.token
        else { return nil }
        
        return token
    }

    func getUserId() -> String? {
        activeUserId
    }

    nonisolated func unsafeGetUserId() -> String? {
        activeUserId
    }

    func getName() -> String? {
        guard let id = activeUserId else { return nil }
        return sessions[id]?.name
    }

    nonisolated func unsafeGetName() -> String? {
        guard let id = activeUserId else { return nil }
        return sessions[id]?.name
    }

    func getEmail() -> String? {
        guard let id = activeUserId else { return nil }
        return sessions[id]?.email
    }

    nonisolated func unsafeGetEmail() -> String? {
        guard let id = activeUserId else { return nil }
        return sessions[id]?.email
    }

    func getRole() -> UserRole? {
        guard let id = activeUserId else { return nil }
        return sessions[id]?.role
    }

    nonisolated func unsafeGetRole() -> UserRole? {
        guard let id = activeUserId else { return nil }
        return sessions[id]?.role
    }
    
    func getActiveSession() -> StoredSession? {
        guard let userId = activeUserId else { return nil }
        return sessions[userId]
    }

    nonisolated func unsafeGetActiveSession() -> StoredSession? {
        guard let userId = activeUserId else { return nil }
        return sessions[userId]
    }
    
    func getAllSessions() -> [StoredSession] {
        Array(sessions.values)
    }
    
    nonisolated func unsafeGetAllSessions() -> [StoredSession] {
        Array(sessions.values)
    }

    func isExpired() -> Bool {
        guard let id = activeUserId,
              let session = sessions[id]
        else { return true }

        if Date() >= session.expiration {
            destroy()
            return true
        }
        return false
    }

    func refresh(token: String) throws(SessionError) {
        let payload = try decodeToken(token)

        guard let userId = payload["sub"] as? String,
              let name = payload["name"] as? String,
              let email = payload["email"] as? String,
              let roleString = payload["role"] as? String,
              let role = UserRole(rawValue: roleString),
              let expirationTs = payload["exp"] as? TimeInterval else {
            throw .missingField
        }

        let expiration = Date(timeIntervalSince1970: expirationTs)

        let session = StoredSession(
            userId: userId,
            token: token,
            name: name,
            email: email,
            role: role,
            expiration: expiration
        )

        sessions[userId] = session
        try persistSession(session)
        try persistSessionIDs()
        try setActiveSession(userId)
    }

    func destroy() {
        guard let id = activeUserId else { return }

        sessions.removeValue(forKey: id)
        try? deleteSessionFromKeychain(id)

        activeUserId = nil
        try? keychain.delete(forKey: SessionKeychainKey.activeSession.key)
        try? persistSessionIDs()
    }

    func switchToSession(_ userId: String) throws(SessionError) {
        guard sessions[userId] != nil else { throw .notFound }
        try setActiveSession(userId)
    }
    
    // MARK: - Private Methods

    private func loadAllSessions() {
        guard let data = try? keychain.readData(forKey: SessionKeychainKey.sessionIDs.key),
              let ids = try? JSONDecoder().decode([String].self, from: data)
        else { return }

        for id in ids {
            let dataKey = SessionKeychainKey.sessionData(id).key
            if let data = try? keychain.readData(forKey: dataKey),
               let session = try? JSONDecoder().decode(StoredSession.self, from: data) {
                sessions[id] = session
            }
        }
    }

    private func loadActiveSession() {
        guard let idString = try? keychain.read(forKey: SessionKeychainKey.activeSession.key)
        else { return }
        activeUserId = idString
    }

    private func persistSession(_ session: StoredSession) throws(SessionError) {
        do {
            let encoded = try JSONEncoder().encode(session)
            try keychain.save(encoded, forKey: SessionKeychainKey.sessionData(session.userId).key)
            try keychain.save(session.token, forKey: SessionKeychainKey.sessionToken(session.userId).key)
        } catch {
            throw .keychainError
        }
    }

    private func persistSessionIDs() throws(SessionError) {
        do {
            let ids = Array(sessions.keys)
            let encoded = try JSONEncoder().encode(ids)
            try keychain.save(encoded, forKey: SessionKeychainKey.sessionIDs.key)
        } catch {
            throw .keychainError
        }
    }

    private func deleteSessionFromKeychain(_ userId: String) throws(SessionError) {
        do {
            try keychain.delete(forKey: SessionKeychainKey.sessionToken(userId).key)
            try keychain.delete(forKey: SessionKeychainKey.sessionData(userId).key)
        } catch {
            throw .keychainError
        }
    }

    private func setActiveSession(_ userId: String) throws(SessionError) {
        do {
            activeUserId = userId
            try keychain.save(userId, forKey: SessionKeychainKey.activeSession.key)
        } catch {
            throw .keychainError
        }
    }

    private func decodeToken(_ token: String) throws(SessionError) -> [String: Any] {
        let parts = token.components(separatedBy: ".")
        guard parts.count == 3 else { throw .invalidToken }
        return try decodeBase64(encodedString: parts[1])
    }

    private func decodeBase64(encodedString: String) throws(SessionError) -> [String: Any] {
        var base64 = encodedString
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        let padding = 4 - (base64.count % 4)
        if padding != 4 { base64 += String(repeating: "=", count: padding) }

        guard let data = Data(base64Encoded: base64),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else { throw .decodingError }

        return json
    }
}
