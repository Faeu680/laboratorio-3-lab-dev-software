//
//  LanguageSelectScreenViewResource.swift
//  Meritus
//
//  Created by Arthur Porto on 24/11/25.
//

import Foundation

enum LanguageSelectScreenViewResource: String, CaseIterable, ResourceSelectScreenViewProtocol {
    case portuguese
    case english
    case spanish
    case system
    
    init(from locale: Locale) {
        let id = locale.identifier.lowercased()

        switch id {
        case "pt_br":
            self = .portuguese
        case "en_us":
            self = .english
        case "es_es":
            self = .spanish
        default:
            self = .system
        }
    }
    
    var title: String {
        switch self {
        case .portuguese:
            return "Português (BR)"
        case .english:
            return "Inglês"
        case .spanish:
            return "Espanhol"
        case .system:
            return "Sistema"
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
        case .system:
            return .current
        }
    }
}
