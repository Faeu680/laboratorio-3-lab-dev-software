//
//  NetworkingDependencyInjection.swift
//  Networking
//
//  Created by Arthur Porto on 17/10/25.
//

import Foundation
import DependencyInjection

public struct NetworkingDependencyInjection: DependencyModule {
    
    // MARK: - Public Methods
    
    public static func register(in container: Container) {
        registerNetworkClient(in: container)
    }
    
    // MARK: - Private Methods
    
    private static func registerNetworkClient(in container: Container) {
        container.register(NetworkDebugStoreProtocol.self) { _ in
            NetworkDebugStore()
        }
        .inObjectScope(.container)
        
        container.register(NetworkClientProtocol.self) { resolver in
            let store = resolver.resolveUnwrapping(NetworkDebugStoreProtocol.self)
            let session = NetworkSessionFactory.make(store: store)
            return NetworkClient(session: session)
        }.inObjectScope(.container)
    }
}
