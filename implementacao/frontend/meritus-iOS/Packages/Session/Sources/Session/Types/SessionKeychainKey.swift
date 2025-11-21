//
//  SessionKeychainKey.swift
//  Session
//
//  Created by Arthur Porto on 21/11/25.
//

import Foundation

enum SessionKeychainKey {
    case sessionToken(String)
    case sessionData(String)
    case sessionIDs
    case activeSession

    var key: String {
        switch self {
        case let .sessionToken(userId):
            return "session_\(userId)_token"
        case let .sessionData(userId):
            return "session_\(userId)_data"
        case .sessionIDs:
            return "session_ids"
        case .activeSession:
            return "session_active"
        }
    }
}
