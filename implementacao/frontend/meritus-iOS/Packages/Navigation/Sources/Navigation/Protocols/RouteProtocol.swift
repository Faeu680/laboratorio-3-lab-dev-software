//
//  RouteProtocol.swift
//  Navigation
//
//  Created by Arthur Porto on 31/10/25.
//

public protocol RouteProtocol: Hashable, Identifiable {
    var id: String { get }
}

public extension RouteProtocol {
    var id: String { String(describing: Self.self) }
}
