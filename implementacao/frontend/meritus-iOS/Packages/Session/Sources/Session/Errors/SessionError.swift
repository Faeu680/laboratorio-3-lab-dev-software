//
//  SessionError.swift
//  Session
//
//  Created by Arthur Porto on 29/10/25.
//

public enum SessionError: Error {
    case invalidToken
    case decodingError
    case missingField
}
