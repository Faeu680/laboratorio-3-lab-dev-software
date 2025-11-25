//
//  AppLanguage+Extensions.swift
//  Meritus
//
//  Created by Arthur Porto on 24/11/25.
//

import Commons
import SwiftUI

extension AppLanguage {
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
}
