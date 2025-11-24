//
//  ColorSchemeSelectScreenViewModel.swift
//  Meritus
//
//  Created by Arthur Porto on 18/11/25.
//

import SwiftUI
import Combine

final class ColorSchemeSelectScreenViewModel: ResourceSelectScreenViewModelProtocol {
    private let manager: ColorSchemeManager
    
    let toolbarTitle: String = "Aparência"
    
    @Published var selectedResource: ColorSchemeSelectScreenViewResource = .system
    
    var availableResources: [ColorSchemeSelectScreenViewResource] {
        ColorSchemeSelectScreenViewResource.allCases
    }
    
    init() {
        let manager = ColorSchemeManager.shared
        self.manager = manager
        self.selectedResource = .init(from: manager.getColorScheme())
    }
    
    func select(_ resource: ColorSchemeSelectScreenViewResource) {
        selectedResource = resource
        setColorScheme(resource)
    }
    
    private func setColorScheme(_ resource: ColorSchemeSelectScreenViewResource) {
        let colorScheme = resource.colorSchemeType
        manager.setColorScheme(colorScheme)
    }
}
