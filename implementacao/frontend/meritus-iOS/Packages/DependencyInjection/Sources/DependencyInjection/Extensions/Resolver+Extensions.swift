//
//  Resolver+Extensions.swift
//  DependencyInjection
//
//  Created by Arthur Porto on 17/10/25.
//

import Swinject

extension Swinject.Resolver {
    public func resolveUnwrapping<Service>(_ serviceType: Service.Type) -> Service {
        guard let service = resolve(serviceType) else {
            fatalError("Could not resolve \(serviceType)")
        }
        return service
    }
    
    public func resolveUnwrapping<Service>(_ serviceType: Service.Type, name: String?) -> Service {
        guard let service = resolve(serviceType, name: name) else {
            fatalError("Could not resolve \(serviceType) with name: \(name ?? "nil")")
        }
        return service
    }
    
    public func resolveUnwrapping<Service, Arg1>(_ serviceType: Service.Type, argument: Arg1) -> Service {
        guard let service = resolve(serviceType, argument: argument) else {
            fatalError("Could not resolve \(serviceType) with argument")
        }
        return service
    }
    
    public func resolveUnwrapping<Service, Arg1>(_ serviceType: Service.Type, name: String?, argument: Arg1) -> Service {
        guard let service = resolve(serviceType, name: name, argument: argument) else {
            fatalError("Could not resolve \(serviceType) with name: \(name ?? "nil") and argument")
        }
        return service
    }
    
    public func resolveUnwrapping<Service, Arg1, Arg2>(_ serviceType: Service.Type, arguments arg1: Arg1, _ arg2: Arg2) -> Service {
        guard let service = resolve(serviceType, arguments: arg1, arg2) else {
            fatalError("Could not resolve \(serviceType) with 2 arguments")
        }
        return service
    }
    
    public func resolveUnwrapping<Service, Arg1, Arg2>(_ serviceType: Service.Type, name: String?, arguments arg1: Arg1, _ arg2: Arg2) -> Service {
        guard let service = resolve(serviceType, name: name, arguments: arg1, arg2) else {
            fatalError("Could not resolve \(serviceType) with name: \(name ?? "nil") and 2 arguments")
        }
        return service
    }
    
    public func resolveUnwrapping<Service, Arg1, Arg2, Arg3>(_ serviceType: Service.Type, arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3) -> Service {
        guard let service = resolve(serviceType, arguments: arg1, arg2, arg3) else {
            fatalError("Could not resolve \(serviceType) with 3 arguments")
        }
        return service
    }
    
    public func resolveUnwrapping<Service, Arg1, Arg2, Arg3>(_ serviceType: Service.Type, name: String?, arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3) -> Service {
        guard let service = resolve(serviceType, name: name, arguments: arg1, arg2, arg3) else {
            fatalError("Could not resolve \(serviceType) with name: \(name ?? "nil") and 3 arguments")
        }
        return service
    }
}
