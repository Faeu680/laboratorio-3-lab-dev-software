//
//  AppDependencyInjection.swift
//  Meritus
//
//  Created by Arthur Porto on 31/10/25.
//

import DependencyInjection
import Navigation

public struct AppDependencyInjection: DependencyModule {
    
    // MARK: - Public Methods
    
    public static func register(in container: Container) {
        registerServices(in: container)
    }
    
    // MARK: - Private Methods
    
    private static func registerServices(in container: Container) {
        container.register(RouteFactoryProtocol.self) { resolver in
            return RouteFactory(resolver: resolver)
        }
        
        container.register(AppRouteRegister.self) { resolver in
            let factory = resolver.resolveUnwrapping(RouteFactoryProtocol.self)
            return AppRouteRegister(factory: factory)
        }
    }
}
