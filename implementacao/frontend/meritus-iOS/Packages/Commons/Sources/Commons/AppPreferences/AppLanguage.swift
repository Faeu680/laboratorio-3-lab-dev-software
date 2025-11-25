//
//  AppLanguage.swift
//  Commons
//
//  Created by Arthur Porto on 24/11/25.
//

import Foundation

public enum AppLanguage: String, CaseIterable, Sendable {
    case portuguese = "pt_BR"
    case english = "en_US"
    case spanish = "es_ES"
    case system = "system"
}

public extension AppLanguage {
    init?(fromSystemLocaleIdentifier identifier: String) {
        switch identifier {
        case "pt_BR":
            self = .portuguese
        case "en_US":
            self = .english
        case "es_ES":
            self = .spanish
        default:
            return nil
        }
    }
    
    var locale: Locale {
        switch self {
        case .portuguese:
            return .init(identifier: "pt_BR")
        case .english:
            return .init(identifier: "en_US")
        case .spanish:
            return .init(identifier: "es_ES")
        case .system:
            return .autoupdatingCurrent
        }
    }
    
    init(locale: Locale) {
        switch locale.identifier {
        case "pt_BR":
            self = .portuguese
        case "en_US":
            self = .english
        case "es_ES":
            self = .spanish
        default:
            self = .system
        }
    }
}
