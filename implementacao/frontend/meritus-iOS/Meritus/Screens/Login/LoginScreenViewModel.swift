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
    
    init(signInUseCase: SignInUseCaseProtocol) {
        self.signInUseCase = signInUseCase
    }
    
    func didTapSignIn() async {
        try? await signInUseCase.execute(email: email, password: password)
    }
}
