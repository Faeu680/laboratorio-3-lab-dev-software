//
//  AppDependencyInjection.swift
//  Meritus
//
//  Created by Arthur Porto on 31/10/25.
//

import DependencyInjection
import Navigation

struct AppDependencyInjection: DependencyModule {
    
    // MARK: - Public Methods
    
    static func register(in container: Container) {
        registerServices(in: container)
    }
    
    // MARK: - Private Methods
    
    private static func registerServices(in container: Container) {
        container.register(AppRouteFactoryProtocol.self) { resolver in
            return AppRouteFactory(resolver: resolver)
        }
        
        container.register(AppRouteRegister.self) { resolver in
            let factory = resolver.resolveUnwrapping(AppRouteFactoryProtocol.self)
            return AppRouteRegister(factory: factory)
        }
    }
}
