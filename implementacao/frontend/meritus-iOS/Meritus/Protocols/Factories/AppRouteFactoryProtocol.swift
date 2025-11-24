//
//  AppRouteFactoryProtocol.swift
//  Meritus
//
//  Created by Arthur Porto on 31/10/25.
//

@MainActor
protocol AppRouteFactoryProtocol: Sendable {
    func makeLogin() -> LoginScreenView
    
    func makeSignUp() -> SignUpScreenView
    
    func makeHome() -> HomeScreenView
    
    func makeExtract() -> ExtractScreenView
    
    func makeTransfer() -> TransferScreenView
    
    func makeBenefits() -> BenefitsScreenView
    
    func makeNewBenefit() -> NewBenefitScreenView
    
    func makeRedeem() -> RedeemScreenView
    
    func makeSettings() -> SettingsScreenView
    
    func makeSelectLanguage() -> ResourceSelectScreenView<LanguageSelectScreenViewModel>
    
    func makeSelectColorScheme() -> ResourceSelectScreenView<ColorSchemeSelectScreenViewModel>
    
    func makeSwitchAccount() -> SwitchAccountScreenView
}
