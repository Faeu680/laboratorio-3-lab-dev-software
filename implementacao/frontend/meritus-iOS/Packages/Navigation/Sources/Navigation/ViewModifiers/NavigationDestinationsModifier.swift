//
//  NavigationDestinationsModifier.swift
//  Navigation
//
//  Created by Arthur Porto on 31/10/25.
//

import SwiftUI

struct NavigationDestinationsModifier<Routes: RouteRegisterProtocol>: ViewModifier {
    let registers: [Routes]

    func body(content: Content) -> some View {
        registers.reduce(AnyView(content)) { partial, register in
            AnyView(
                partial.navigationDestination(for: Routes.Route.self) { route in
                    register.makeDestination(for: route)
                }
            )
        }
    }
}
