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
        case .extract:
            factory.makeExtract()
        case .transfer:
            factory.makeTransfer()
        case .benefits:
            factory.makeBenefits()
        case .myBenefits:
            factory.makeMyBenefits()
        case let .benefitInfo(benefit):
            factory.makeBenefitInfo(benefit: benefit)
        case .newBenefit:
            factory.makeNewBenefit()
        case .settings:
            factory.makeSettings()
        case .selectColorScheme:
            factory.makeSelectColorScheme()
        case .switchAccount:
            factory.makeSwitchAccount()
        case let .feedback(style):
            factory.makeFeedback(style: style)
        }
    }
}
