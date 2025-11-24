//
//  ColorSchemeManager.swift
//  Meritus
//
//  Created by Arthur Porto on 18/11/25.
//

import SwiftUI
import Combine

@MainActor
final class ColorSchemeManager: ObservableObject {
    @Published var colorScheme: ColorScheme?
    
    static let shared = ColorSchemeManager()
    
    private init() {}
    
    func getColorScheme() -> ColorScheme? {
        colorScheme
    }
    
    func setColorScheme(_ colorScheme: ColorScheme?) {
        self.colorScheme = colorScheme
    }
}
