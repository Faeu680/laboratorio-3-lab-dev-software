//
//  AppRouteFactoryProtocol.swift
//  Meritus
//
//  Created by Arthur Porto on 31/10/25.
//

protocol AppRouteFactoryProtocol: Sendable {
    @MainActor
    func makeLogin() -> LoginScreenView
    
    @MainActor
    func makeSignUp() -> SignUpScreenView
    
    @MainActor
    func makeHome() -> HomeScreenView
    
    @MainActor
    func makeBenefits() -> BenefitsScreenView
    
    @MainActor
    func makeRedeem() -> RedeemScreenView
}
