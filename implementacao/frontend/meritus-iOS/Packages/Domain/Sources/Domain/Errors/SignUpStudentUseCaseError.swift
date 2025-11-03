//
//  SignUpStudentUseCaseError.swift
//  Domain
//
//  Created by Arthur Porto on 02/11/25.
//

public enum SignUpStudentUseCaseError: Error {
    case invalidData
    case keychainError
    case initSessionError
    case userAlreadyExists
    case institutionNotFound
    case unknown
}
