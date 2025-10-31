//
//  RouteRegisterProtocol.swift
//  Navigation
//
//  Created by Arthur Porto on 31/10/25.
//

import SwiftUI

public protocol RouteRegisterProtocol {
    associatedtype Route: RouteProtocol
    associatedtype Destination: View
    
    @MainActor
    @ViewBuilder
    func makeDestination(for route: Route) -> Destination
}
