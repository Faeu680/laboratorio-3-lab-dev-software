//
//  AppRoutes.swift
//  Meritus
//
//  Created by Arthur Porto on 31/10/25.
//

import Navigation
import Session

enum AppRoutes: RouteProtocol {
    var id: String { "" }
    
    case login
    case switchAccountLogin(chooseAccount: StoredSession)
    case signup
    case home
    case extract
    case benefits
    case newBenefit
    case redeem
    case settings
    case selectLanguage
    case selectColorScheme
    case switchAccount
}
