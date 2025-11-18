//
//  ColorSchemeManager.swift
//  Meritus
//
//  Created by Arthur Porto on 18/11/25.
//

import SwiftUI
import Combine

@MainActor
final class ColorSchemeManager: ColorSchemeManagerProtocol {
    @Published var colorScheme: ColorScheme?
    
    nonisolated init() {}
    
    func setColorScheme(_ colorScheme: ColorScheme?) {
        self.colorScheme = colorScheme
    }
}
