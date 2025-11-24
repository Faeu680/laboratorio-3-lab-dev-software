//
//  LanguageSelectScreenViewModel.swift
//  Meritus
//
//  Created by Arthur Porto on 18/11/25.
//

import Foundation
import Combine

final class LanguageSelectScreenViewModel: ResourceSelectScreenViewModelProtocol {
    private let manager: LocalizationManager
    
    let toolbarTitle: String = "Linguagem"
    
    @Published var selectedResource: LanguageSelectScreenViewResource = .portuguese
    
    var availableResources: [LanguageSelectScreenViewResource] {
        LanguageSelectScreenViewResource.allCases
    }
    
    init() {
        let manager = LocalizationManager.shared
        self.manager = manager
        self.selectedResource = .init(from: manager.getLocale())
    }
    
    func select(_ resource: LanguageSelectScreenViewResource) {
        selectedResource = resource
        setLanguage(resource)
    }
    
    private func setLanguage(_ resource: LanguageSelectScreenViewResource) {
        let locale = resource.localeType
        manager.setLocale(locale)
    }
}
