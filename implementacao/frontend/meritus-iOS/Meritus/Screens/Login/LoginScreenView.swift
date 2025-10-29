//
//  LoginScreenView.swift
//  Meritus
//
//  Created by Arthur Porto on 17/10/25.
//

import SwiftUI
import Obsidian

struct LoginScreenView: View {
    
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
            print("Navigate")
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
            label: "EMAIL",
            placeholder: "seu@email.com",
            keyboardType: .emailAddress
        )
    }
}

extension LoginScreenView {
    private func passwordInputView() -> some View {
        ObsidianInput(
            text: $viewModel.password,
            label: "Senha",
            placeholder: "seu@email.com"
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
            "Cadastro",
            style: .secondary
        ) {
            print("Primary tapped")
        }
    }
}

