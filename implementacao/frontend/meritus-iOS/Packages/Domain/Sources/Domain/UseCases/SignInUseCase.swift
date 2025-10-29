//
//  SignInUseCase.swift
//  Domain
//
//  Created by Arthur Porto on 17/10/25.
//

import Commons
import Networking
import Session

final class SignInUseCase: SignInUseCaseProtocol {
    private let service: AuthServiceProtocol
    private let session: SessionProtocol
    private let keychain = KeychainManager.shared

    init(
        service: AuthServiceProtocol,
        session: SessionProtocol
    ) {
        self.service = service
        self.session = session
    }

    func execute(email: String, password: String) async throws(SignInUseCaseError) {
        do {
            let token = try await service.signIn(email: email, password: password)
            try await session.refresh(token: token)
            try keychain.save(token, for: "authToken")
        } catch {
            throw mapError(error)
        }
    }
    
    // MARK: - Private Methods
    
    private func mapError(_ error: Error) -> SignInUseCaseError {
        if let serviceError = error as? ServiceError, case .unauthorized = serviceError {
            return .invalidData
        }
        
        if error is SessionError {
            return .initSessionError
        }
        
        if error is KeychainError {
            return .keychainError
        }
        
        return .unknown
    }
}
