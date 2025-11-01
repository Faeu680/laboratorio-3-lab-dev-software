//
//  SignUpScreenView.swift
//  Meritus
//
//  Created by Arthur Porto on 01/11/25.
//

import SwiftUI
import Obsidian

struct SignUpScreenView: View {
    
    @StateObject private var viewModel: SignUpScreenViewModel
    
    init(viewModel: SignUpScreenViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    private var studentButtonStyle: ObsidianButton.Style {
        let isDisabled = viewModel.signUpType != .student
        return isDisabled ? .outline : .primary
    }
    
    private var businessButtonStyle: ObsidianButton.Style {
        let isDisabled = viewModel.signUpType != .business
        return isDisabled ? .outline : .primary
    }
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.signUpType.fieldKeys, id: \.self) { key in
                    fieldView(for: key)
                    
                    Spacer()
                        .frame(maxWidth: .infinity)
                        .frame(height: .size4)
                }
                .padding(.vertical, .size16)
            }
            .scrollIndicators(.never)
            .toolbarTitleDisplayMode(.inlineLarge)
            .navigationTitle("Solicitar Acesso")
            
            if !viewModel.isCurrentFormComplete {
                tabView()
            } else {
                signUpButtonView()
            }
        }
    }
}

extension SignUpScreenView {
    private func tabView() -> some View {
        HStack {
            ObsidianButton(
                "Aluno",
                style: studentButtonStyle
            ) {
                viewModel.didTapStudent()
            }
            
            ObsidianButton(
                "Empresa",
                style: businessButtonStyle
            ) {
                viewModel.didTapBusiness()
            }
        }
        .padding(.horizontal, .size16)
    }
}

extension SignUpScreenView {
    @ViewBuilder
    private func fieldView(for key: SignUpType.FieldKey) -> some View {
        let text = viewModel.binding(key)
        
        ObsidianInput(
            text: text,
            label: key.label,
            placeholder: key.placeholder,
            keyboardType: key.keyboard,
        )
        .padding(.horizontal, .size16)
    }
}

extension SignUpScreenView {
    private func signUpButtonView() -> some View {
        ObsidianButton(
            "Cadastro",
            style: .primary,
            isDisabled: .constant(!viewModel.isCurrentFormComplete)
        ) {
            print("Primary tapped")
        }
        .padding(.horizontal, .size16)
    }
}

#Preview {
    SignUpScreenView(
        viewModel: .init()
    )
}
