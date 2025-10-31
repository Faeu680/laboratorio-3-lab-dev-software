//
//  BootstrapSessionUseCase.swift
//  Domain
//
//  Created by Arthur Porto on 31/10/25.
//

import Session

final class BootstrapSessionUseCase: BootstrapSessionUseCaseProtocol {
    private let session: SessionProtocol
    
    init(session: SessionProtocol) {
        self.session = session
    }
    
    func execute() async throws(BootstrapSessionError) {
        let isExpired = await session.isExpired()
        
        guard !isExpired else {
            throw .needsSignIn
        }
    }
}
