//
//  View+Extensions.swift
//  Navigation
//
//  Created by Arthur Porto on 31/10/25.
//

import SwiftUI

extension View {
    func navigationDestinations<Routes: RouteRegisterProtocol>(_ registers: [Routes]) -> some View {
        self.modifier(NavigationDestinationsModifier(registers: registers))
    }
}
