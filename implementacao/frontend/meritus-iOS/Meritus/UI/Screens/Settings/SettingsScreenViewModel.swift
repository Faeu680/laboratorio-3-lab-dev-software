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

    private let session: SessionProtocol
    private let colorSchemeManager = ColorSchemeManager.shared

    let name: String
    let email: String

    @Published var currentColorScheme: String = ""

    init(session: SessionProtocol) {
        self.session = session
        self.name = session.unsafeGetName() ?? "Anonymous"
        self.email = session.unsafeGetEmail() ?? "Anonymous"
    }
    
    func task() {
        refresh()
    }
    
    func didTapLogout() async {
        await session.destroy()
    }

    private func refresh() {
        currentColorScheme = colorSchemeManager
            .scheme
            .title
    }
}
