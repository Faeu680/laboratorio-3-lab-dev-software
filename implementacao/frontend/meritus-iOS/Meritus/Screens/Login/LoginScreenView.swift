//
//  LoginScreenView.swift
//  Meritus
//
//  Created by Arthur Porto on 17/10/25.
//

import SwiftUI
import Obsidian
import Navigation

struct LoginScreenView: View {
    
    @Environment(\.navigator) private var navigator: NavigatorProtocol
    
    @StateObject private var viewModel: LoginScreenViewModel
    
    init(viewModel: LoginScreenViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            logoView()
                .padding(.top, .size48)
            
            Spacer()
            
            VStack(spacing: .size24) {
                emailInputView()
                
                passwordInputView()
            }
            
            Spacer()
            
            VStack(spacing: .size24) {
                signInButtonView()
                
                signUpButtonView()
            }
            
            Text("Experiencia Premium")
                .obsidianLabel()
                .padding(.top, .size48)
                .padding(.bottom, .size24)
        }
        .padding(.horizontal, .size16)
        .onViewDidLoad {
            bindActions()
        }
    }
}

extension LoginScreenView {
    private func bindActions() {
        viewModel.onLoginSuccess = {
            navigator.navigate(to: AppRoutes.home)
        }
        
        viewModel.onLoginFailure = { error in
            // TODO: Show Error
        }
    }
}

extension LoginScreenView {
    private func logoView() -> some View {
        VStack(spacing: .size24) {
            Text("MERITUS")
                .meritusTitle()
            
            Text("Acesso exclusivo")
                .obsidianLabel()
        }
    }
}

extension LoginScreenView {
    private func emailInputView() -> some View {
        ObsidianInput(
            text: $viewModel.email,
            label: LocalizableKey.LoginScreen.emailLabel,
            placeholder: LocalizableKey.LoginScreen.emailPlaceholder,
            keyboardType: .emailAddress
        )
    }
}

extension LoginScreenView {
    private func passwordInputView() -> some View {
        ObsidianInput(
            text: $viewModel.password,
            label: LocalizableKey.LoginScreen.passwordLabel,
            placeholder: LocalizableKey.LoginScreen.passwordPlaceholder
        )
    }
}

extension LoginScreenView {
    private func signInButtonView() -> some View {
        ObsidianButton(
            "Entrar",
            style: .primary,
            isLoading: $viewModel.isLoading
        ) {
            Task {
                await viewModel.didTapSignIn()
            }
        }
    }
}

extension LoginScreenView {
    private func signUpButtonView() -> some View {
        ObsidianButton(
            "Solicitar Acesso",
            style: .secondary
        ) {
            navigator.navigate(to: AppRoutes.signup)
        }
    }
}
