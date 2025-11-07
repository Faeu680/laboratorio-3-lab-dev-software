//
//  AppRouteRegister.swift
//  Meritus
//
//  Created by Arthur Porto on 31/10/25.
//

import SwiftUI
import Navigation

final class AppRouteRegister: RouteRegisterProtocol {
    private let factory: AppRouteFactoryProtocol
    
    init(factory: AppRouteFactoryProtocol) {
        self.factory = factory
    }
    
    @MainActor
    @ViewBuilder
    func makeDestination(for route: AppRoutes) -> some View {
        switch route {
        case .login:
            factory.makeLogin()
        case .signup:
            factory.makeSignUp()
        case .home:
            factory.makeHome()
        case .benefits:
            factory.makeBenefits()
        case .redeem:
            factory.makeRedeem()
        }
    }
}
