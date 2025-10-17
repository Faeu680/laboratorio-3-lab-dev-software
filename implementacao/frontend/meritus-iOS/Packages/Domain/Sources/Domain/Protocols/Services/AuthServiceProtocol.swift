//
//  AuthServiceProtocol.swift
//  Domain
//
//  Created by Arthur Porto on 17/10/25.
//

public protocol AuthServiceProtocol: Sendable {
    func signIn(email: String, password: String) async throws -> String
}
