//
//  SplashScreenViewModel.swift
//  Meritus
//
//  Created by Arthur Porto on 31/10/25.
//

import Combine
import Domain

@MainActor
final class SplashScreenViewModel: ObservableObject {
    private let bootsrapUseCase: BootstrapSessionUseCaseProtocol
    
    var onLoginSuccess: (() -> Void)?
    var onLoginFailure: (() -> Void)?
    
    init(bootsrapUseCase: BootstrapSessionUseCaseProtocol) {
        self.bootsrapUseCase = bootsrapUseCase
    }
    
    func onViewDidLoad() async {
        do {
            try await bootsrapUseCase.execute()
            onLoginSuccess?()
        } catch {
            onLoginFailure?()
        }
    }
}
