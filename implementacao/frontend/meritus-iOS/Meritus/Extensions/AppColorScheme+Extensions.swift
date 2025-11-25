//
//  AppColorScheme+Extensions.swift
//  Meritus
//
//  Created by Arthur Porto on 24/11/25.
//

import Commons

extension AppColorScheme {
    var title: String {
        switch self {
        case .light:
            return "Claro"
        case .dark:
            return "Escuro"
        case .system:
            return "Sistema"
        }
    }
}
