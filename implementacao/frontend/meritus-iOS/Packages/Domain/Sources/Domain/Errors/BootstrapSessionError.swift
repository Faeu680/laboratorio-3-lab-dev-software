//
//  BootstrapSessionError.swift
//  Domain
//
//  Created by Arthur Porto on 31/10/25.
//

public enum BootstrapSessionError: Error {
    case needsSignIn
    case keychainError
    case initSessionError
    case unknown
}
