//
//  SessionDependencyInjection.swift
//  Session
//
//  Created by Arthur Porto on 29/10/25.
//

import DependencyInjection

public struct SessionDependencyInjection: DependencyModule {
    
    // MARK: - Public Methods
    
    public static func register(in container: Container) {
        registerServices(in: container)
    }
    
    // MARK: - Private Methods
    
    private static func registerServices(in container: Container) {
        container.register(SessionProtocol.self) { _ in
            return Session()
        }.inObjectScope(.container)
    }
}
