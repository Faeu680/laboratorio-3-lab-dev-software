//
//  AppDependencies.swift
//  DependencyInjection
//
//  Created by Arthur Porto on 17/10/25.
//

@preconcurrency @_exported import Swinject

public final class AppDependencies {
    
    private nonisolated(unsafe) static let _container = Container()
    private nonisolated(unsafe) static let _resolver = _container.synchronize()
    
    private init() {}
    
    public static var resolver: Resolver { _resolver }
    public static var container: Container { _container }
    
    public static func setupAll(modules: [any DependencyModule.Type]) {
        modules.forEach { module in
            module.register(in: container)
        }
    }
}
