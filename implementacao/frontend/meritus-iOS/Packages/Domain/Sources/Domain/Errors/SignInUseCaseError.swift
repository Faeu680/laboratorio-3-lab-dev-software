//
//  SignInUseCaseError.swift
//  Domain
//
//  Created by Arthur Porto on 29/10/25.
//

public enum SignInUseCaseError: Error {
    case invalidData
    case keychainError
    case initSessionError
    case unknown
}
