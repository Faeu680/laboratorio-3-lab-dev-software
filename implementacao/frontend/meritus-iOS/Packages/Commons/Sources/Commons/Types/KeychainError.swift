//
//  KeychainError.swift
//  Domain
//
//  Created by Arthur Porto on 17/10/25.
//

import Foundation

public enum KeychainError: Error, LocalizedError {
    case encodingError
    case decodingError
    case unhandledError(OSStatus)
}
