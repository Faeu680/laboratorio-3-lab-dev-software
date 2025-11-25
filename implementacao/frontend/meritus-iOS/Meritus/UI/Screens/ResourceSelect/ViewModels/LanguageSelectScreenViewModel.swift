//
//  LanguageSelectScreenViewModel.swift
//  Meritus
//
//  Created by Arthur Porto on 18/11/25.
//

import Foundation
import Combine
import Commons

final class LanguageSelectScreenViewModel: ResourceSelectScreenViewModelProtocol {
    private let manager: LocalizationManager
    
    @Published private(set) var selectedResource: AppLanguage
    
    let availableResources = AppLanguage.allCases
    let toolbarTitle = "Selecionar Idioma"
    
    init() {
        let manager = LocalizationManager.shared
        self.manager = manager
        self.selectedResource = manager.language
    }
    
    func select(_ resource: AppLanguage) {
        selectedResource = resource
        manager.setLanguage(resource)
    }
}
