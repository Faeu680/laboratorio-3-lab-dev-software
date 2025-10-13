//
//  ResolverProtocol.swift
//  DependencyInjection
//
//  Created by Arthur Porto on 13/10/25.
//

public protocol ResolverProtocol: Sendable {
    func resolve<Service>(_ type: Service.Type, name: String?) -> Service?
    
    func resolve<Service, each Arg>(
        _ type: Service.Type,
        name: String?,
        arguments: repeat each Arg
    ) -> Service?
    
    func resolveUnwrapping<Service>(_ type: Service.Type, name: String?) -> Service
    
    func resolveUnwrapping<Service, each Arg>(
        _ type: Service.Type,
        name: String?,
        arguments: repeat each Arg
    ) -> Service
}
