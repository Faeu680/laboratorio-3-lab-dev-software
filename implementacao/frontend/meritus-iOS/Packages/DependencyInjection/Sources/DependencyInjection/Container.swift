//
//  Container.swift
//  DependencyInjection
//
//  Created by Arthur Porto on 13/10/25.
//

import Foundation
import Synchronization

final class Container: @unchecked Sendable {
    
    // MARK: - Private Properties
    
    private var services: [String: ServiceEntry] = [:]
    private let lock = Mutex<Void>(())
    
    // MARK: - Public Properties
    
    static let shared: Container = Container()
    
    // MARK: - Init
    
    private init() {}
}

// MARK: - ContainerProtocol

extension Container: ContainerProtocol {
    @discardableResult
    func register<Service>(
        _ type: Service.Type,
        name: String? = nil,
        scope: Scope = .transient,
        factory: @escaping (ResolverProtocol) -> Service
    ) -> Self {
        let key = makeKey(for: type, name: name)
        
        lock.withLock {_ in 
            services[key] = ServiceEntry(scope: scope) { resolver in
                factory(resolver)
            }
        }
        
        return self
    }
    
    @discardableResult
    func register<Service, each Arg>(
        _ type: Service.Type,
        name: String? = nil,
        scope: Scope = .transient,
        factory: @escaping (ResolverProtocol, repeat each Arg) -> Service
    ) -> Self {
        var key = String(describing: type)
        if let name = name {
            key += "_name:\(name)"
        }
        key += "_args:\(String(describing: (repeat (each Arg).self)))"
        
        lock.withLock {_ in
            services[key] = ServiceEntry(scope: scope) { resolver in
                fatalError("Use resolve(_:name:arguments:) to resolve dependencies with arguments")
            }
            
            let wrappedKey = "\(key)_factory"
            services[wrappedKey] = ServiceEntry(scope: .transient) { _ in factory }
        }
        
        return self
    }
    
    func removeAll() {
        lock.withLock {_ in
            services.removeAll()
        }
    }
}

// MARK: - ResolverProtocol

extension Container: ResolverProtocol {
    func resolve<Service>(_ type: Service.Type, name: String? = nil) -> Service? {
        let key = makeKey(for: type, name: name)
        
        return lock.withLock {_ in 
            guard let entry = services[key] else {
                return nil
            }
            return entry.resolve(container: self) as? Service
        }
    }
    
    func resolve<Service, each Arg>(
        _ type: Service.Type,
        name: String? = nil,
        arguments: repeat each Arg
    ) -> Service? {
        var key = String(describing: type)
        if let name = name {
            key += "_name:\(name)"
        }
        key += "_args:\(String(describing: (repeat (each Arg).self)))"
        
        let wrappedKey = "\(key)_factory"
        
        return lock.withLock {_ in
            guard let factoryEntry = services[wrappedKey],
                  let factory = factoryEntry.factory(self) as? (ResolverProtocol, repeat each Arg) -> Service else {
                return nil
            }
            return factory(self, repeat each arguments)
        }
    }
    
    func resolveUnwrapping<Service>(_ type: Service.Type, name: String? = nil) -> Service {
        guard let resolved = resolve(type, name: name) else {
            let nameInfo = name.map { " (name: \($0))" } ?? ""
            fatalError("Unable to resolve dependency: \(type)\(nameInfo)")
        }
        return resolved
    }
    
    func resolveUnwrapping<Service, each Arg>(
        _ type: Service.Type,
        name: String? = nil,
        arguments: repeat each Arg
    ) -> Service {
        guard let resolved = resolve(type, name: name, arguments: repeat each arguments) else {
            let nameInfo = name.map { " (name: \($0))" } ?? ""
            fatalError("Unable to resolve dependency: \(type)\(nameInfo) with arguments")
        }
        return resolved
    }
}

// MARK: - Private Methods

extension Container {
    private func makeKey<T>(for type: T.Type, name: String? = nil) -> String {
        var key = String(describing: type)
        
        if let name = name {
            key += "_name:\(name)"
        }
        
        return key
    }
}
