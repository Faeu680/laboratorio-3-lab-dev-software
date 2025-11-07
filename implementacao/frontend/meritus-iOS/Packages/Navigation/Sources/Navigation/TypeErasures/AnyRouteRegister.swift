//
//  AnyRouteRegister.swift
//  Navigation
//
//  Created by Arthur Porto on 07/11/25.
//

import SwiftUI

public struct AnyRouteRegister {
    private let _canHandle: (AnyHashable) -> Bool
    
    private let _makeDestination: @MainActor (AnyHashable) -> AnyView?

    public init<R: RouteRegisterProtocol>(_ register: R) {
        _canHandle = { any in any is R.Route }
        _makeDestination = { any in
            guard let route = any as? R.Route else { return nil }
            return AnyView(register.makeDestination(for: route))
        }
    }

    func canHandle(_ route: AnyHashable) -> Bool { _canHandle(route) }
    
    @MainActor
    func makeDestination(for route: AnyHashable) -> AnyView? { _makeDestination(route) }
}
