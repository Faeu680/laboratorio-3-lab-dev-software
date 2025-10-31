//
//  DomainDependencyInjection.swift
//  Domain
//
//  Created by Arthur Porto on 17/10/25.
//

import Foundation
import DependencyInjection
import Commons
import Session

public struct DomainDependencyInjection: DependencyModule {
    
    // MARK: - Public Methods
    
    public static func register(in container: Container) {
        registerUseCases(in: container)
    }
    
    // MARK: - Private Methods
    
    private static func registerUseCases(in container: Container) {
        container.register(SignInUseCaseProtocol.self) { resolver in
            let service = resolver.resolveUnwrapping(AuthServiceProtocol.self)
            let session = resolver.resolveUnwrapping(SessionProtocol.self)
            return SignInUseCase(service: service, session: session)
        }
        
        container.register(BootstrapSessionUseCaseProtocol.self) { resolver in
            let session = resolver.resolveUnwrapping(SessionProtocol.self)
            return BootstrapSessionUseCase(session: session)
        }
    }
}
