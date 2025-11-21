//
//  SwitchAccountScreenView.swift
//  Meritus
//
//  Created by Arthur Porto on 18/11/25.
//

import SwiftUI
import Obsidian

struct SwitchAccountScreenView: View {
    
    @StateObject private var viewModel: SwitchAccountScreenViewModel
    
    init(viewModel: SwitchAccountScreenViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            ObsidianList(verticalPadding: .size8) {
                accountListItemView()
                accountListItemView()
                accountListItemView()
            }
            .navigationTitle("Trocar de Conta")
            .toolbarTitleDisplayMode(.inlineLarge)
            
            VStack(spacing: .size16) {
                addNewAccountButtonView()
                logoutButtonView()
            }
            .padding(.horizontal, .size16)
            .padding(.bottom, .size16)
        }
    }
}

extension SwitchAccountScreenView {
    private func accountListItemView() -> some View {
        ObsidianListItem(
            title: "João da Silva",
            subtitle: "joao@example.com",
            leading: ObsidianAvatar(initials: "JS", size: .medium),
            trailing: Image(systemName: "chevron.right"),
            borderStyle: .regular // se selecionado aplicar dashed
        )
    }
}

extension SwitchAccountScreenView {
    private func addNewAccountButtonView() -> some View {
        ObsidianButton(
            "Adicionar Conta",
            style: .outline
        ) {
            return
        }
    }
}

extension SwitchAccountScreenView {
    private func logoutButtonView() -> some View {
        ObsidianButton(
            "Sair do App",
            style: .destructiveOutline
        ) {
//            navigator.popTo(AppRoutes.login)
        }
    }
}

#Preview {
    ObsidianPreviewContainer {
        SwitchAccountScreenView(viewModel: .init())
    }
}
