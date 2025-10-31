//
//  RouteProtocol.swift
//  Navigation
//
//  Created by Arthur Porto on 31/10/25.
//

public protocol RouteProtocol: CaseIterable, Hashable, Identifiable {
    var id: String { get }
}
