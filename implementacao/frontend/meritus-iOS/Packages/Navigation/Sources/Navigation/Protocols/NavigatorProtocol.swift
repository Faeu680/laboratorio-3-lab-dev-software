//
//  NavigatorProtocol.swift
//  Navigation
//
//  Created by Arthur Porto on 29/10/25.
//

@MainActor
public protocol NavigatorProtocol {
    func navigate<Route: RouteProtocol>(to route: Route)
    func pop()
    func popToRoot()
    func pop(count: Int)
}
