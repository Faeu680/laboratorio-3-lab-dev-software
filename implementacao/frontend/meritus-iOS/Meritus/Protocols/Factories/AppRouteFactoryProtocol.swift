//
//  AppRouteFactoryProtocol.swift
//  Meritus
//
//  Created by Arthur Porto on 31/10/25.
//

import Domain
import Obsidian

@MainActor
protocol AppRouteFactoryProtocol: Sendable {
    func makeLogin() -> LoginScreenView
    
    func makeSignUp() -> SignUpScreenView
    
    func makeHome() -> HomeScreenView
    
    func makeExtract() -> ExtractScreenView
    
    func makeTransfer() -> TransferScreenView
    
    func makeBenefits() -> BenefitsScreenView
    
    func makeMyBenefits() -> MyBenefitsScreenView
    
    func makeBenefitInfo(benefit: RedeemBenefitModel) -> BenefitInfoScreenView
    
    func makeNewBenefit() -> NewBenefitScreenView
    
    func makeSettings() -> SettingsScreenView
    
    func makeSelectColorScheme() -> ResourceSelectScreenView<ColorSchemeSelectScreenViewModel>
    
    func makeSwitchAccount() -> SwitchAccountScreenView
    
    func makeFeedback(style: ObsidianFeedbackView.Style) -> ObsidianFeedbackView
}
