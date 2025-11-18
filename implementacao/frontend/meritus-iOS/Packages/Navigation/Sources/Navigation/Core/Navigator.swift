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
    @Published var path = NavigationPath() {
        didSet { syncStackWithPath() }
    }
    private var stack: [AnyHashable] = []
    private var registers: [AnyRouteRegister] = []

    static let shared = Navigator()
    
    private init() {}

    func configure(registers: [AnyRouteRegister]) {
        self.registers = registers
    }
    
    private func syncStackWithPath() {
        let pathCount = path.count
        let stackCount = stack.count

        if pathCount < stackCount {
            let numberOfItemsToRemove = stackCount - pathCount
            stack.removeLast(numberOfItemsToRemove)
        } else if pathCount > stackCount {
            stack.removeAll()
        }
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
        stack.append(AnyHashable(route))
        path.append(route)
    }

    func navigate<Route: RouteProtocol>(to routes: [Route]) {
        for r in routes {
            stack.append(AnyHashable(r))
            path.append(r)
        }
    }

    func pop() {
        guard !stack.isEmpty, !path.isEmpty else { return }
        stack.removeLast()
        path.removeLast()
    }

    func pop(count: Int) {
        let removeCount = min(count, stack.count)
        guard removeCount > 0 else { return }

        stack.removeLast(removeCount)
        path.removeLast(removeCount)
    }

    func popTo<Route: RouteProtocol>(_ target: Route) {
        let key = AnyHashable(target)

        guard let idx = stack.lastIndex(of: key) else { return }

        let removeCount = stack.count - (idx + 1)
        guard removeCount > 0 else { return }

        stack.removeLast(removeCount)
        path.removeLast(removeCount)
    }

    func popToRoot() {
        stack.removeAll()
        path = NavigationPath()
    }
}
