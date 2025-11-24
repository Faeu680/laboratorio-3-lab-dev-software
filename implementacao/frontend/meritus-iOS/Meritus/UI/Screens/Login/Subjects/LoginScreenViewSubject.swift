//
//  LoginScreenViewSubject.swift
//  Meritus
//
//  Created by Arthur Porto on 23/11/25.
//

import Session

@MainActor
final class LoginScreenViewSubject {
    private var action: LoginScreenViewAction = .login
    
    static let shared = LoginScreenViewSubject()
    
    private init() {}
    
    func getLoginAction() -> LoginScreenViewAction {
        self.action
    }
    
    func setLoginAction(_ action: LoginScreenViewAction) {
        self.action = action
    }
}
