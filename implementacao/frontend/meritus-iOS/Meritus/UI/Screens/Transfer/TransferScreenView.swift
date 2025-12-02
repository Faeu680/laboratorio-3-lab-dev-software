//
//  TransferScreenView.swift
//  Meritus
//
//  Created by Arthur Porto on 03/11/25.
//

import SwiftUI
import AudioToolbox
import Obsidian
import Domain
import Session
import Commons

struct TransferScreenView: View {
    
    @StateObject private var viewModel: TransferScreenViewModel
    
    private let feedbaackGenerator = UINotificationFeedbackGenerator()
    
    init(viewModel: TransferScreenViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ObsidianList(verticalPadding: .size8) {
            ForEach(viewModel.filteredStudents, id: \.id) { student in
                userListItemView(student)
            }
        }
        .navigationTitle("Transferências")
        .navigationSubtitle("Selecione um aluno para realizar uma transferência")
        .toolbarTitleDisplayMode(.inlineLarge)
        .searchable(
            text: $viewModel.searchText,
            prompt: "Buscar por nome ou email"
        )
        .fullScreenCover(isPresented: $viewModel.showTransferModal) {
            NavigationStack {
                transferModalView()
            }
        }
        .onAppear {
            await viewModel.onViewDidLoad()
        }
    }
}

extension TransferScreenView {
    private func userListItemView(_ student: StudentModel) -> some View {
        ObsidianListItem(
            title: student.name,
            subtitle: student.email,
            leading: userListItemAvatarView(),
            trailing: Image(systemName: "chevron.right")
        ) {
            await viewModel.didSelectStudent(student)
        }
    }
}

extension TransferScreenView {
    private func userListItemAvatarView() -> some View {
        ZStack {
            Circle()
                .fill(Color.obsidianGold.opacity(0.18))

            Image(systemName: "person.crop.circle")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.obsidianGold)
        }
        .frame(width: 44, height: 44)
        .overlay(
            Circle().stroke(Color.white.opacity(0.05), lineWidth: 0.5)
        )
    }
}

extension TransferScreenView {
    private func selectedUserItemView(
        sectionTitle: String,
        isCurrentAccount: Bool,
        name: String,
        email: String
    ) -> some View {
        VStack(spacing: .size16) {
            Text(sectionTitle)
                .obsidianBody()
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .lineLimit(1)
            
            ObsidianListItem(
                title: name,
                subtitle: email,
                leading: Image(systemName: "person.crop.circle.fill"),
                borderStyle: isCurrentAccount ? .regular : .dashed
            )
        }
        .padding(.horizontal, .size16)
    }
}

extension TransferScreenView {
    private func transferModalView() -> some View {
        ScrollView {
            transferInputView()
            
            VStack {
                balanceListItem(
                    title: "Saldo Atual",
                    balance: viewModel.balance
                )
                
                balanceListItem(
                    title: "Saldo Final",
                    balance: viewModel.finalBalance
                )
            }
            .padding(.top, .size16)
            
            VStack(spacing: .size24) {
                fromAccountView()
                
                toAccountView()
            }
            .padding(.top, .size24)
            
            descriptionTextAreaView()
                .padding(.top, .size24)
            
            transferButtonView()
                .padding(.top, .size24)
        }
        .scrollIndicators(.never)
        .scrollDismissesKeyboard(.immediately)
        .navigationTitle("Transferir")
        .toolbarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.dismissTransferModal()
                } label: {
                    Image(systemName: "xmark")
                        .font(.headline)
                }
            }
        }
        .navigationDestination(item: $viewModel.transferResult) { route in
            feedbackView(route)
        }
    }
}

extension TransferScreenView {
    private func transferInputView() -> some View {
        ObsidianCreditInput(
            text: $viewModel.transferAmount,
            title: "Valor",
            unitLabel: "MeritusCredits"
        )
        .padding(.top, .size16)
        .padding(.horizontal, .size16)
    }
}

extension TransferScreenView {
    private func balanceListItem(
        title: String,
        balance: String
    ) -> some View {
        ObsidianListItem(
            title: title,
            trailing: Text("MC \(balance)")
                .obsidianBody()
        )
        .padding(.horizontal, .size16)
    }
}

extension TransferScreenView {
    @ViewBuilder
    private func fromAccountView() -> some View {
        if let currentAccount = viewModel.storedSession {
            selectedUserItemView(
                sectionTitle: "De:",
                isCurrentAccount: true,
                name: currentAccount.name,
                email: currentAccount.email
            )
        }
    }
}

extension TransferScreenView {
    @ViewBuilder
    private func toAccountView() -> some View {
        if let destinationAccount = viewModel.selectedStudent {
            selectedUserItemView(
                sectionTitle: "Para:",
                isCurrentAccount: false,
                name: destinationAccount.name,
                email: destinationAccount.email
            )
        }
    }
}

extension TransferScreenView {
    private func descriptionTextAreaView() -> some View {
        ObsidianTextArea(
            text: $viewModel.description,
            label: "Descrição",
            placeholder: "Escreva uma mensagem...",
            minHeight: 120,
            maxHeight: 120,
            isError: $viewModel.showDescriptionError,
            errorMessage: .constant("A descrição é obrigatória."),
            onFocusChanged: { focused in
                if focused {
                    viewModel.markDescriptionFieldAsTouched()
                }
            }
        )
        .padding(.horizontal, .size16)
    }
}

extension TransferScreenView {
    private func transferButtonView() -> some View {
        ObsidianButton(
            "Transferir",
            style: .primary,
            isLoading: $viewModel.isLoading,
            isDisabled: .constant(!viewModel.isTransferButtonEnabled)
        ) {
            await viewModel.didTapTransferButton()
        }
        .padding(.horizontal, .size16)
        .padding(.bottom, .size16)
    }
}

extension TransferScreenView {
    private func feedbackView(_ route: TransferScreenViewResultRoute) -> some View {
        ObsidianFeedbackView(
            route.feedbackViewStyle
        ) {
            handleTransferUIFeedback(route)
        }
        .toolbar(.hidden)
    }
}

extension TransferScreenView {
    private func handleTransferUIFeedback(_ route: TransferScreenViewResultRoute) {
        feedbaackGenerator.prepare()
        
        defer { viewModel.dismissTransferModal() }
        
        switch route {
        case .success:
            let sucessSoundId: UInt32 = 1519
            feedbaackGenerator.notificationOccurred(.success)
        case .error:
            let errorSoundId: UInt32 = 1520
            feedbaackGenerator.notificationOccurred(.error)
        }
    }
}
