//
//  LoginScreenViewModel.swift
//  Meritus
//
//  Created by Arthur Porto on 17/10/25.
//

import Combine
import Domain

@MainActor
final class LoginScreenViewModel: ObservableObject {
    
    private let signInUseCase: SignInUseCaseProtocol
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    
    var onLoginSuccess: (() -> Void)?
    var onLoginFailure: ((SignInUseCaseError) -> Void)?
    
    init(signInUseCase: SignInUseCaseProtocol) {
        self.signInUseCase = signInUseCase
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
    
    private func clearForm() {
        email = ""
        password = ""
    }
    
    private func handleError(_ error: SignInUseCaseError) {
        
    }
}
