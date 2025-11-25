//
//  AppColorScheme.swift
//  Commons
//
//  Created by Arthur Porto on 24/11/25.
//

import SwiftUI

public enum AppColorScheme: String, CaseIterable, Sendable {
    case light
    case dark
    case system
}

public extension AppColorScheme {
    var colorScheme: ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil
        }
    }
    
    init(colorScheme: ColorScheme?) {
        switch colorScheme {
        case .light:
            self = .light
        case .dark:
            self = .dark
        default:
            self = .system
        }
    }
}
