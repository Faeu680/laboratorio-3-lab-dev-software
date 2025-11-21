//
//  SwitchAccountScreenView.swift
//  Meritus
//
//  Created by Arthur Porto on 18/11/25.
//

import SwiftUI
import Obsidian
import Session
import Navigation

struct SwitchAccountScreenView: View {
    @Environment(\.navigator) private var navigator: NavigatorProtocol
    
    @StateObject private var viewModel: SwitchAccountScreenViewModel
    
    init(viewModel: SwitchAccountScreenViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            ObsidianList(verticalPadding: .size8) {
                ForEach(viewModel.sessions, id: \.userId) { session in
                    accountListItemView(session)
                }
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
    private func accountListItemView(_ session: StoredSession) -> some View {
        ObsidianListItem(
            title: session.name,
            subtitle: session.email,
            leading: ObsidianAvatar(initials: "JS", size: .medium),
            trailing: Image(systemName: "chevron.right"),
            borderStyle: .regular // se selecionado aplicar dashed
        )
        .onTapGesture {
            // TODO: e pra dar popup
            navigator.navigate(to: AppRoutes.switchAccountLogin(chooseAccount: session))
        }
    }
}

extension SwitchAccountScreenView {
    private func addNewAccountButtonView() -> some View {
        ObsidianButton(
            "Adicionar Conta",
            style: .outline
        ) {
            // TODO: Adicionar bottom sheet avisando antes
            navigator.popTo(AppRoutes.login)
        }
    }
}

extension SwitchAccountScreenView {
    private func logoutButtonView() -> some View {
        ObsidianButton(
            "Sair do App",
            style: .destructiveOutline
        ) {
            return
        }
    }
}
