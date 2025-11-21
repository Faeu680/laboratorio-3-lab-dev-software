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
    func makeNewBenefit() -> NewBenefitScreenView
    
    @MainActor
    func makeRedeem() -> RedeemScreenView
    
    @MainActor
    func makeSettings() -> SettingsScreenView
    
    @MainActor
    func makeSelectLanguage() -> ResourceSelectScreenView<LanguageSelectScreenViewModel>
    
    @MainActor
    func makeSelectColorScheme() -> ResourceSelectScreenView<ColorSchemeSelectScreenViewModel>
    
    @MainActor
    func makeSwitchAccount() -> SwitchAccountScreenView
}
