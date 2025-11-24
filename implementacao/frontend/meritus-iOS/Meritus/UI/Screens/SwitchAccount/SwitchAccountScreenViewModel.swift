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
    private let loginSubject: LoginScreenViewSubject = .shared
    
    let shouldHideAddNewAccountButton: Bool
    
    @Published var sessions: [StoredSession]
    
    init(session: SessionProtocol) {
        self.session = session
        self.sessions = session.unsafeGetAllSessions()
        self.shouldHideAddNewAccountButton = !session.unsafeIsActive
    }
    
    func didTapToSwitchAccount(_ choosedSession: StoredSession) {
        let action: LoginScreenViewAction = .switchAccount(
            choosedSession: choosedSession
        )
        
        loginSubject.setLoginAction(action)
    }
    
    func didSwipeToDeleteAccount(_ userId: String) async {
        await session.destroy(userId: userId)
    }
    
    func didTapToAddNewAccount() async {
        await session.logout()
    }
}
