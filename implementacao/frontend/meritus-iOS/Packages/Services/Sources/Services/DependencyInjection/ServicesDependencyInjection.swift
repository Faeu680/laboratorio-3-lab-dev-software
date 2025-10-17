//
//  ServicesDependencyInjection.swift
//  Services
//
//  Created by Arthur Porto on 17/10/25.
//

import Foundation
import Networking
import DependencyInjection
import Domain

public struct ServicesDependencyInjection: DependencyModule {
    
    // MARK: - Public Methods
    
    public static func register(in container: Container) {
        registerServices(in: container)
    }
    
    // MARK: - Private Methods
    
    private static func registerServices(in container: Container) {
        container.register(AuthServiceProtocol.self) { resolver in
            let network = resolver.resolveUnwrapping(NetworkClientProtocol.self)
            return AuthService(network: network)
        }
    }
}
