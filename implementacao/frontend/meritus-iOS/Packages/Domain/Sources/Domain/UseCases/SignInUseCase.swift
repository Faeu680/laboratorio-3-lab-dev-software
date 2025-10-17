//
//  SignInUseCase.swift
//  Domain
//
//  Created by Arthur Porto on 17/10/25.
//

import Commons

final class SignInUseCase: SignInUseCaseProtocol {
    private let service: AuthServiceProtocol
    private let keychain = KeychainManager.shared

    init(service: AuthServiceProtocol) {
        self.service = service
    }

    func execute(email: String, password: String) async throws {
        let token = try await service.signIn(email: email, password: password)
        try keychain.save(token, for: "authToken")
    }
}
