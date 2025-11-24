//
//  LoginScreenViewAction.swift
//  Meritus
//
//  Created by Arthur Porto on 21/11/25.
//

import Session

enum LoginScreenViewAction: Equatable, Hashable {
    case login
    case switchAccount(choosedSession: StoredSession)
}
