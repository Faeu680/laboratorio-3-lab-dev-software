//
//  LanguageSelectScreenViewModel.swift
//  Meritus
//
//  Created by Arthur Porto on 18/11/25.
//

import Foundation
import Combine

final class LanguageSelectScreenViewModel: ResourceSelectScreenViewModelProtocol {
    
    enum LanguageResource: String, CaseIterable, ResourceType {
        case portuguese
        case english
        case spanish
        
        var title: String {
            switch self {
            case .portuguese: return "Português (BR)"
            case .english: return "Inglês"
            case .spanish: return "Espanhol"
            }
        }
        
        var localeType: Locale {
            switch self {
            case .portuguese:
                return Locale(identifier: "pt_BR")
            case .english:
                return Locale(identifier: "en_US")
            case .spanish:
                return Locale(identifier: "es_ES")
            }
        }
    }
    
    private let manager: LocalizationManagerProtocol
    
    let toolbarTitle: String = "Linguagem"
    
    @Published var selectedResource: LanguageResource = .portuguese
    
    var availableResources: [LanguageResource] {
        LanguageResource.allCases
    }
    
    init(manager: LocalizationManagerProtocol) {
        self.manager = manager
    }
    
    func select(_ resource: LanguageResource) {
        selectedResource = resource
    }
    
    private func setLanguage(_ resource: LanguageResource) {
        let locale = resource.localeType
        manager.setLocale(locale)
    }
}
