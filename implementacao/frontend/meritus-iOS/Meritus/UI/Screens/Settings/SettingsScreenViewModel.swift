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

    @Published var currentLocation: String = ""
    @Published var currentColorScheme: String = ""

    init(session: SessionProtocol) {
        self.name = session.unsafeGetName() ?? "Anonymous"
        self.email = session.unsafeGetEmail() ?? "Anonymous"
    }
    
    func task() {
        refresh()
    }

    private func refresh() {
        currentLocation = locationManager
            .language
            .title
        
        currentColorScheme = colorSchemeManager
            .scheme
            .title
    }
}
