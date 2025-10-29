//  KeychainManager.swift
//  Services
//
//  Created by Arthur Porto on 17/10/25.
//

import Foundation
import Security

public final class KeychainManager: Sendable {
    
    public static let shared: KeychainManager = KeychainManager()
    
    private init() {}
    
    public func save(_ value: String, for key: String) throws(KeychainError) {
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.encodingError
        }
        
        try? delete(for: key)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status)
        }
    }
    
    public func read(for key: String) throws(KeychainError) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]
        
        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status != errSecItemNotFound else { return nil }
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status)
        }
        
        guard let data = item as? Data,
              let string = String(data: data, encoding: .utf8) else {
            throw KeychainError.decodingError
        }
        
        return string
    }
    
    public func delete(for key: String) throws(KeychainError) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status)
        }
    }
}
