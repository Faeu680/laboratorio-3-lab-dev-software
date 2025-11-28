//
//  AppRoutes.swift
//  Meritus
//
//  Created by Arthur Porto on 31/10/25.
//

import Navigation
import Session
import Domain
import Obsidian

enum AppRoutes: RouteProtocol {
    case login
    case signup
    case home
    case extract
    case transfer
    case benefits
    case myBenefits
    case benefitInfo(benefit: RedeemBenefitModel)
    case newBenefit
    case settings
    case selectColorScheme
    case switchAccount
    case feedback(style: ObsidianFeedbackView.Style)
}
