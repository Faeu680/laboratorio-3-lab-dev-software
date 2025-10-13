//
//  ServiceEntry.swift
//  DependencyInjection
//
//  Created by Arthur Porto on 13/10/25.
//

final class ServiceEntry {
    
    // MARK: - Private Properties
    
    private let scope: Scope
    private var instance: Any?
    private weak var weakInstance: AnyObject?
    
    // MARK: - Public Properties
    
    let factory: (ResolverProtocol) -> Any
    
    // MARK: - Init
    
    init(scope: Scope, factory: @escaping (ResolverProtocol) -> Any) {
        self.scope = scope
        self.factory = factory
    }
    
    // MARK: - Public Methods
    
    func resolve(container: ResolverProtocol) -> Any {
        switch scope {
        case .transient:
            return factory(container)
            
        case .singleton:
            if let instance = instance {
                return instance
            }
            let newInstance = factory(container)
            instance = newInstance
            return newInstance
            
        case .weakSingleton:
            if let weakInstance = weakInstance {
                return weakInstance
            }
            let newInstance = factory(container)
            weakInstance = newInstance as AnyObject
            return newInstance
        }
    }
}
