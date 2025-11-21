//
//  LocalizationManager.swift
//  Meritus
//
//  Created by Arthur Porto on 18/11/25.
//

import Foundation
import Combine

@MainActor
final class LocalizationManager: ObservableObject {
    @Published var locale: Locale = Locale(identifier: "pt_BR")
    
    static let shared = LocalizationManager()
    
    private init() {}
    
    func setLocale(_ locale: Locale) {
        self.locale = locale
    }
}
