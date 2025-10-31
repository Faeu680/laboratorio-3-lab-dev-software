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
    
    static let shared = Navigator()
    
    private init() {}
}

extension Navigator: NavigatorProtocol {
    func navigate<Route: RouteProtocol>(to route: Route) {
        path.append(route)
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
