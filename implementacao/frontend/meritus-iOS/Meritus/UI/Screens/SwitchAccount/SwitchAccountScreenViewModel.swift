//
//  SwitchAccountScreenViewModel.swift
//  Meritus
//
//  Created by Arthur Porto on 18/11/25.
//

import Combine
import Session

@MainActor
final class SwitchAccountScreenViewModel: ObservableObject {
    private let session: SessionProtocol
    
    @Published var sessions: [StoredSession]
    
    init(session: SessionProtocol) {
        self.session = session
        self.sessions = session.unsafeGetAllSessions()
    }
}
