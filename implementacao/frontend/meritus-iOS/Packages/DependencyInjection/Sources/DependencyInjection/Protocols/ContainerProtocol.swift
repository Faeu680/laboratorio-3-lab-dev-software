//
//  ContainerProtocol.swift
//  DependencyInjection
//
//  Created by Arthur Porto on 13/10/25.
//

public protocol ContainerProtocol: Sendable {
    static var shared: Self { get }
    
    @discardableResult
    func register<Service>(
        _ type: Service.Type,
        name: String?,
        scope: Scope,
        factory: @escaping (ResolverProtocol) -> Service
    ) -> Self
    
    @discardableResult
    func register<Service, each Arg>(
        _ type: Service.Type,
        name: String?,
        scope: Scope,
        factory: @escaping (ResolverProtocol, repeat each Arg) -> Service
    ) -> Self
    
    func removeAll()
}
