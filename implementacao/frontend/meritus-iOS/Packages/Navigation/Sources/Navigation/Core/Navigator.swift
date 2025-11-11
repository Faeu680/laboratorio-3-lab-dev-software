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
    private var stack: [AnyHashable] = []
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
        let any = AnyHashable(route)
        stack.append(any)
        path.append(route)
    }

    func navigate<Route: RouteProtocol>(to routes: [Route]) {
        for r in routes {
            let any = AnyHashable(r)
            stack.append(any)
            path.append(r)
        }
    }

    func pop() {
        guard !path.isEmpty else { return }
        stack.removeLast()
        path.removeLast()
    }
    
    func popTo<Route: RouteProtocol>(_ target: Route) {
        let anyTarget = AnyHashable(target)
        guard let idx = stack.lastIndex(where: { $0 == anyTarget }) else {
            return
        }
        
        let removeCount = stack.count - (idx + 1)
        guard removeCount > 0 else { return }
        stack.removeLast(removeCount)
        path.removeLast(removeCount)
    }

    func popToRoot() {
        stack.removeAll()
        path = NavigationPath()
    }

    func pop(count: Int) {
        let removeCount = min(count, path.count)
        guard removeCount > 0 else { return }
        stack.removeLast(removeCount)
        path.removeLast(removeCount)
    }
}
