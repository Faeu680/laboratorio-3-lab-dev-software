//
//  SettingsScreenViewModel.swift
//  Meritus
//
//  Created by Arthur Porto on 17/11/25.
//

import Combine
import Session

@MainActor
final class SettingsScreenViewModel: ObservableObject {
    let name: String
    let email: String
    
    init(session: SessionProtocol) {
        self.name = session.unsafeGetEmail() ?? "Anonymous"
        self.email = session.unsafeGetEmail() ?? "Anonymous"
    }
}
