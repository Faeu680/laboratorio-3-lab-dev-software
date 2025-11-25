//
//  UserDefaultsManager.swift
//  Commons
//
//  Created by Arthur Porto on 24/11/25.
//

import Foundation

public final class UserDefaultsManager: Sendable {
    
    // MARK: - Private Properties
    
    private nonisolated(unsafe) let defaults: UserDefaults = .standard
    
    // MARK: - Public Properties
    
    public static let shared = UserDefaultsManager()
    
    // MARK: - Private Init
    
    private init() {}
    
    // MARK: - Public Methods
    
    @discardableResult
    public func save(_ value: String, forKey key: String) -> Bool {
        defaults.set(value, forKey: key)
        return defaults.synchronize()
    }
    
    public func readString(forKey key: String) -> String? {
        defaults.string(forKey: key)
    }
    
    @discardableResult
    public func save(_ data: Data, forKey key: String) -> Bool {
        defaults.set(data, forKey: key)
        return defaults.synchronize()
    }
    
    public func readData(forKey key: String) -> Data? {
        defaults.data(forKey: key)
    }
    
    public func saveCodable<T: Codable>(_ value: T, forKey key: String) throws(UserDefaultsError) {
        do {
            let data = try JSONEncoder().encode(value)
            defaults.set(data, forKey: key)
        } catch {
            throw UserDefaultsError.encodingError
        }
    }
    
    public func readCodable<T: Codable>(_ type: T.Type, forKey key: String) throws(UserDefaultsError) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw UserDefaultsError.decodingError
        }
    }
    
    public func delete(forKey key: String) {
        defaults.removeObject(forKey: key)
    }
    
    public func exists(_ key: String) -> Bool {
        defaults.object(forKey: key) != nil
    }
}
