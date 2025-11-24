//
//  LoginScreenViewSubject.swift
//  Meritus
//
//  Created by Arthur Porto on 23/11/25.
//

import Session

final actor LoginScreenViewSubject {
    private var action: LoginScreenViewAction = .login
    
    static let shared = LoginScreenViewSubject()
    
    private init() {}
    
    func getLoginAction() -> LoginScreenViewAction {
        action
    }
    
    func setLoginAction(_ action: LoginScreenViewAction) {
        self.action = action
    }
}
