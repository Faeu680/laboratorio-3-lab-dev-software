//
//  ColorSchemeSelectScreenViewResource.swift
//  Meritus
//
//  Created by Arthur Porto on 24/11/25.
//

import SwiftUI

enum ColorSchemeSelectScreenViewResource: String, CaseIterable, ResourceSelectScreenViewProtocol {
    case light
    case dark
    case system
    
    init(from colorScheme: ColorScheme?) {
        guard let colorScheme else {
            self = .system
            return
        }
        
        switch colorScheme {
        case .light:
            self = .light
        case .dark:
            self = .dark
        @unknown default:
            self = .system
        }
    }
    
    var title: String {
        switch self {
        case .light: return "Claro"
        case .dark: return "Escuro"
        case .system: return "Sistema"
        }
    }
    
    var colorSchemeType: ColorScheme? {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
}
