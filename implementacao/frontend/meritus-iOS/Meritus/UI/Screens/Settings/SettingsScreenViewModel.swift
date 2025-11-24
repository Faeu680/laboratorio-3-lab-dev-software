//
//  SettingsScreenViewModel.swift
//  Meritus
//
//  Created by Arthur Porto on 17/11/25.
//

import SwiftUI
import Combine
import Session

@MainActor
final class SettingsScreenViewModel: ObservableObject {

    private let locationManager = LocalizationManager.shared
    private let colorSchemeManager = ColorSchemeManager.shared

    let name: String
    let email: String

    @Published var currentLocation: String
    @Published var currentColorScheme: String

    init(session: SessionProtocol) {
        self.name = session.unsafeGetName() ?? "Anonymous"
        self.email = session.unsafeGetEmail() ?? "Anonymous"

        self._currentLocation = .init(
            initialValue: locationManager
                .getLocale()
                .toString()
        )
        self._currentColorScheme = .init(
            initialValue: colorSchemeManager
                .getColorScheme()
                .toString()
        )
    }
    
    func onAppear() {
        refresh()
    }

    private func refresh() {
        currentLocation = locationManager
            .getLocale()
            .toString()
        
        currentColorScheme = colorSchemeManager
            .getColorScheme()
            .toString()
    }
}

fileprivate extension ColorScheme? {
    func toString() -> String {
        switch self {
        case .light:
            return "Claro"
        case .dark:
            return "Escuro"
        case .none:
            return "Sistema"
        @unknown default:
            return "Sistema"
        }
    }
}

fileprivate extension Locale {
    func toString() -> String {
        let id = identifier.lowercased()

        switch id {
        case "pt_br":
            return "Português (BR)"
        case "en_us":
            return "Inglês"
        case "es_es":
            return "Espanhol"
        default:
            return "Sistema"
        }
    }
}
