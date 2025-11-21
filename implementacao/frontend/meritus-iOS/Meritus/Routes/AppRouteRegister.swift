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
        case .newBenifit:
            factory.makeNewBenefit()
        case .redeem:
            factory.makeRedeem()
        case .settings:
            factory.makeSettings()
        case .selectLanguage:
            factory.makeSelectLanguage()
        case .selectColorScheme:
            factory.makeSelectColorScheme()
        case .switchAccount:
            factory.makeSwitchAccount()
        }
    }
}
