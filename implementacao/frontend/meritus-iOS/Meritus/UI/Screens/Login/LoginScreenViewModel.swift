//
//  LoginScreenViewModel.swift
//  Meritus
//
//  Created by Arthur Porto on 17/10/25.
//

import Combine
import Domain
import Session

@MainActor
final class LoginScreenViewModel: ObservableObject {
    
    private let action: LoginScreenViewAction
    private let session: SessionProtocol
    private let signInUseCase: SignInUseCaseProtocol
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    
    var onLoginSuccess: (() -> Void)?
    var onLoginFailure: ((SignInUseCaseError) -> Void)?
    
    init(
        action: LoginScreenViewAction,
        session: SessionProtocol,
        signInUseCase: SignInUseCaseProtocol
    ) {
        self.action = action
        self.session = session
        self.signInUseCase = signInUseCase
    }
    
    func onViewDidLoad() async {
        guard case let .switchAccount(choosedSession) = action else {
            return
        }
        
        await didSelectToSwitchAccount(choosedSession)
    }
    
    func didTapSignIn() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await signInUseCase.execute(email: email, password: password)
            onLoginSuccess?()
            clearForm()
        } catch {
            handleError(error)
        }
    }
    
    func didSelectToSwitchAccount(_ choosedSession: StoredSession) async {
        // TODO: Adcionar face id
        
        email = choosedSession.email
        
        do {
            try await session.switchToSession(choosedSession.userId)
            onLoginSuccess?()
        } catch {
            // TODO: cuidar do erro de trocar sessão
        }
    }
    
    private func clearForm() {
        email = ""
        password = ""
    }
    
    private func handleError(_ error: SignInUseCaseError) {
        
    }
}
