//
//  ColorSchemeSelectScreenViewModel.swift
//  Meritus
//
//  Created by Arthur Porto on 18/11/25.
//

import SwiftUI
import Combine
import Commons

final class ColorSchemeSelectScreenViewModel: ResourceSelectScreenViewModelProtocol {
    private let manager: ColorSchemeManager
    
    @Published private(set) var selectedResource: AppColorScheme
    
    let availableResources = AppColorScheme.allCases
    let toolbarTitle = "Tema do Aplicativo"
    
    init() {
        let manager = ColorSchemeManager.shared
        self.manager = manager
        self.selectedResource = manager.scheme
    }
    
    func select(_ resource: AppColorScheme) {
        selectedResource = resource
        manager.setScheme(resource)
    }
}
