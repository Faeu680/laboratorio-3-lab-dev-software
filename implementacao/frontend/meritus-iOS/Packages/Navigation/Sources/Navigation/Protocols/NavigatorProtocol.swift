//
//  NavigatorProtocol.swift
//  Navigation
//
//  Created by Arthur Porto on 29/10/25.
//

import SwiftUI

@MainActor
public protocol NavigatorProtocol {
    func view<Route: RouteProtocol>(for route: Route) -> AnyView?
    func navigate<Route: RouteProtocol>(to route: Route)
    func navigate<Route: RouteProtocol>(to routes: [Route])
    func pop()
    func popToRoot()
    func pop(count: Int)
}
