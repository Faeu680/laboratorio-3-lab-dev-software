//
//  ColorSchemeSelectScreenViewModel.swift
//  Meritus
//
//  Created by Arthur Porto on 18/11/25.
//

import SwiftUI
import Combine

final class ColorSchemeSelectScreenViewModel: ResourceSelectScreenViewModelProtocol {
    
    enum ColorSchemeResource: String, CaseIterable, ResourceType {
        case light
        case dark
        case system
        
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
    
    private let manager = ColorSchemeManager.shared
    
    let toolbarTitle: String = "Aparência"
    
    @Published var selectedResource: ColorSchemeResource = .system
    
    var availableResources: [ColorSchemeResource] {
        ColorSchemeResource.allCases
    }
    
    func select(_ resource: ColorSchemeResource) {
        selectedResource = resource
        setColorScheme(resource)
    }
    
    private func setColorScheme(_ resource: ColorSchemeResource) {
        let colorScheme = resource.colorSchemeType
        manager.setColorScheme(colorScheme)
    }
}
