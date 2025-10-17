//
//  SignInUseCaseProtocol.swift
//  Domain
//
//  Created by Arthur Porto on 17/10/25.
//

public protocol SignInUseCaseProtocol: Sendable {
    func execute(email: String, password: String) async throws
}
