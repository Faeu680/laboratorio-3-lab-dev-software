//
//  SettingsScreenView.swift
//  Meritus
//
//  Created by Arthur Porto on 17/11/25.
//

import SwiftUI
import Obsidian
import Navigation

struct SettingsScreenView: View {
    @Environment(\.navigator) private var navigator: NavigatorProtocol
    
    @StateObject private var viewModel: SettingsScreenViewModel
    
    init(viewModel: SettingsScreenViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: .size32) {
                avatarView()
                
                VStack(spacing: .size24) {
                    nameInputView()
                    emailInputView()
                }
                
                VStack {
                    languageListItemView()
                    appearanceListItemView()
                    changeAccountListItemView()
                }
            }
            .padding(.top, .size24)
        }
        .navigationTitle("Ajustes")
        .toolbarTitleDisplayMode(.inlineLarge)
    }
}

extension SettingsScreenView {
    private func avatarView() -> some View {
        ObsidianAvatar(initials: "JD")
    }
}

extension SettingsScreenView {
    private func nameInputView() -> some View {
        ObsidianInput(
            text: .constant(viewModel.name),
            label: "Nome Completo",
            placeholder: ""
        )
        .padding(.horizontal, .size16)
        .disabled(true)
    }
}

extension SettingsScreenView {
    private func emailInputView() -> some View {
        ObsidianInput(
            text: .constant(viewModel.email),
            label: "Email",
            placeholder: ""
        )
        .padding(.horizontal, .size16)
        .disabled(true)
    }
}

extension SettingsScreenView {
    private func languageListItemView() -> some View {
        ObsidianListItem(
            title: "Idioma",
            subtitle: "Português (BR)",
            leading: Image(systemName: "globe"),
            trailing: Image(systemName: "chevron.right")
        )
        .padding(.horizontal, .size16)
        .onTapGesture {
            navigator.navigate(to: AppRoutes.selectLanguage)
        }
    }
}

extension SettingsScreenView {
    private func appearanceListItemView() -> some View {
        ObsidianListItem(
            title: "Aparência",
            subtitle: "Automático",
            leading: Image(systemName: "circle.lefthalf.filled"),
            trailing: Image(systemName: "chevron.right")
        )
        .padding(.horizontal, .size16)
        .onTapGesture {
            navigator.navigate(to: AppRoutes.selectColorScheme)
        }
    }
}

extension SettingsScreenView {
    private func changeAccountListItemView() -> some View {
        ObsidianListItem(
            title: "Trocar de Conta",
            subtitle: "Entrar com outro usuário",
            leading: Image(systemName: "person.crop.circle"),
            trailing: Image(systemName: "chevron.right")
        )
        .padding(.horizontal, .size16)
        .onTapGesture {
            navigator.navigate(to: AppRoutes.switchAccount)
        }
    }
}
