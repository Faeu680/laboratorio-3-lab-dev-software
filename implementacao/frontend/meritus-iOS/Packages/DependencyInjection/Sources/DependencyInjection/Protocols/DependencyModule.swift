//
//  DependencyModule.swift
//  DependencyInjection
//
//  Created by Arthur Porto on 17/10/25.
//

public protocol DependencyModule: Sendable {
    static func register(in container: Container)
}
