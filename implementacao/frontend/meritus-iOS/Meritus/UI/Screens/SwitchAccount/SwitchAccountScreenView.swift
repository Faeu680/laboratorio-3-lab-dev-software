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
            
            addNewAccountButtonView()
        }
    }
}

extension SwitchAccountScreenView {
    private func accountListItemView(_ session: StoredSession) -> some View {
        ObsidianListItem(
            title: session.name,
            subtitle: session.email,
            leading: ObsidianAvatar(initials: "JS", size: .medium),
            trailing: session.isActive ? nil : Image(systemName: "chevron.right"),
            badges: listItemBadgesView(session),
            borderStyle: session.isActive ? .dashed : .regular
        )
        .if(!session.isActive) { view in
            view
                .onTap {
                    await viewModel.didTapToSwitchAccount(session)
                    await navigator.popTo(AppRoutes.login)
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        await viewModel.didSwipeToDeleteAccount(session.userId)
                    } label: {
                        Label("Remover", systemImage: "trash")
                    }
                }
        }
    }
}

extension SwitchAccountScreenView {
    private func listItemBadgesView(_ session: StoredSession) -> [ObsidianBadge] {
        var badges: [ObsidianBadge] = []
        let roleBadge = ObsidianBadge(session.role.toString())
        
        badges.append(roleBadge)
        
        if session.isActive {
            let activeBadge = ObsidianBadge("Ativa")
            badges.append(activeBadge)
            return badges
        }
        
        if session.isExpired {
            let expiredBadge = ObsidianBadge("Expirado")
            badges.append(expiredBadge)
        }
        
        return badges
    }
}

extension SwitchAccountScreenView {
    private func addNewAccountButtonView() -> some View {
        ObsidianButton(
            "Adicionar Conta",
            style: .outline
        ) {
            // TODO: Adicionar bottom sheet avisando antes
            await viewModel.didTapToAddNewAccount()
            navigator.popTo(AppRoutes.login)
        }
        .padding(.horizontal, .size16)
        .padding(.bottom, .size16)
        .orEmptyView(viewModel.shouldHideAddNewAccountButton)
    }
}

fileprivate extension UserRole {
    func toString() -> String {
        switch self {
        case .student:
            return "Aluno"
        case .teacher:
            return "Professor"
        case .company:
            return "Empresa"
        }
    }
}
