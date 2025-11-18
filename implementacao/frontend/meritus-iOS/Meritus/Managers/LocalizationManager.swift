//
//  LocalizationManager.swift
//  Meritus
//
//  Created by Arthur Porto on 18/11/25.
//

import Foundation
import Combine

@MainActor
final class LocalizationManager: LocalizationManagerProtocol {
    @Published var locale: Locale = Locale(identifier: "pt_BR")
    
    nonisolated init() {}
    
    func setLocale(_ locale: Locale) {
        self.locale = locale
    }
}
