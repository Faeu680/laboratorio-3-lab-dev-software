//
//  SessionKeychainKey.swift
//  Session
//
//  Created by Arthur Porto on 21/11/25.
//

import Foundation

enum SessionKeychainKey {
    case sessionData(String)
    case sessionIDs

    var key: String {
        switch self {
        case let .sessionData(userId):
            return "session_\(userId)_data"
        case .sessionIDs:
            return "session_ids"
        }
    }
}
