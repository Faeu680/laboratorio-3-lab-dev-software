//
//  LocalizationManager.swift
//  Meritus
//
//  Created by Arthur Porto on 18/11/25.
//

import Foundation
import Combine
import Commons

@MainActor
final class LocalizationManager: ObservableObject {

    private static let userDefaultsManager = UserDefaultsManager.shared
    private static let userDefaultsKey = "selectedLocale"

    static let shared = LocalizationManager()
    
    @Published private(set) var language: AppLanguage

    private init() {
        let raw = Self.userDefaultsManager.readString(forKey: Self.userDefaultsKey)
        self.language = raw.flatMap(AppLanguage.init(rawValue:)) ?? .system
    }

    func setLanguage(_ language: AppLanguage) {
        self.language = language
        Self.userDefaultsManager.save(
            language.rawValue,
            forKey: Self.userDefaultsKey
        )
    }
}
