//
//  ColorSchemeManager.swift
//  Meritus
//
//  Created by Arthur Porto on 18/11/25.
//

import SwiftUI
import Combine
import Commons

@MainActor
final class ColorSchemeManager: ObservableObject {

    private static let userDefaultsManager = UserDefaultsManager.shared
    private static let userDefaultsKey = "selectedColorScheme"

    static let shared = ColorSchemeManager()
    
    @Published private(set) var scheme: AppColorScheme

    private init() {
        let raw = Self.userDefaultsManager.readString(forKey: Self.userDefaultsKey)
        self.scheme = raw.flatMap(AppColorScheme.init(rawValue:)) ?? .system
    }

    func setScheme(_ scheme: AppColorScheme) {
        self.scheme = scheme
        Self.userDefaultsManager.save(
            scheme.rawValue,
            forKey: Self.userDefaultsKey
        )
    }
}
