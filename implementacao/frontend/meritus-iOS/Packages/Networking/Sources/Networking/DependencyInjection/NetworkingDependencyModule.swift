//
//  NetworkingDependencyModule.swift
//  Networking
//
//  Created by Arthur Porto on 17/10/25.
//

import Foundation
import DependencyInjection

public struct NetworkingDependencyModule: DependencyModule {
    
    // MARK: - Public Methods
    
    public static func register(in container: Container) {
        registerNetworkClient(in: container)
    }
    
    // MARK: - Private Methods
    
    private static func registerNetworkClient(in container: Container) {
        container.register(NetworkClientProtocol.self) { resolver in
            return NetworkClient()
        }.inObjectScope(.container)
    }
}
