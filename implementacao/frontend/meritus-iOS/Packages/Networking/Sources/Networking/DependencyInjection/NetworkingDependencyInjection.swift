//
//  NetworkingDependencyInjection.swift
//  Networking
//
//  Created by Arthur Porto on 17/10/25.
//

import Foundation
import DependencyInjection
import Session

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
            let AFSession = NetworkSessionFactory.make(store: store)
            let session = resolver.resolveUnwrapping(SessionProtocol.self)
            return NetworkClient(AFSession: AFSession, session: session)
        }.inObjectScope(.container)
    }
}
