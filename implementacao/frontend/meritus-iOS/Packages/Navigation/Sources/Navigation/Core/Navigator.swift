//
//  Navigator.swift
//  Navigation
//
//  Created by Arthur Porto on 29/10/25.
//

import SwiftUI
import Combine

@MainActor
final class Navigator: ObservableObject {
    @Published var path = NavigationPath()
    private var registers: [AnyRouteRegister] = []
    
    static let shared = Navigator()
    
    private init() {}
    
    func configure(registers: [AnyRouteRegister]) {
        self.registers = registers
    }
}

extension Navigator: NavigatorProtocol {
    func view<Route: RouteProtocol>(for route: Route) -> AnyView? {
        let any = AnyHashable(route)
        for reg in registers where reg.canHandle(any) {
            if let v = reg.makeDestination(for: any) { return v }
        }
        return nil
    }
    
    func navigate<Route: RouteProtocol>(to route: Route) {
        path.append(route)
    }
    
    func navigate<Route: RouteProtocol>(to routes: [Route]) {
        routes.forEach { path.append($0) }
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func pop(count: Int) {
        let removeCount = min(count, path.count)
        path.removeLast(removeCount)
    }
}
