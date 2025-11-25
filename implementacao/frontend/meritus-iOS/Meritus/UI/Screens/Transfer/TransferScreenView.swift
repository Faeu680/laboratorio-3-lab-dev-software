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
        .onViewDidLoad {
            await viewModel.onViewDidLoad()
        }
    }
}

extension TransferScreenView {
    private func userListItemView(_ student: StudentModel) -> some View {
        UserListItem(
            name: student.name,
            email: student.email
        )
        .onTapGesture {
            viewModel.didSelectStudent(student)
        }
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
        VStack {
            ScrollView {
                transferInputView()
                
                VStack {
                    balanceListItem(
                        title: "Saldo Atual",
                        balance: "1000"
                    )
                    
                    balanceListItem(
                        title: "Saldo Final",
                        balance: "990"
                    )
                }
                .padding(.top, .size16)
                
                VStack(spacing: .size24) {
                    fromAccountView()
                    
                    toAccountView()
                }
                .padding(.top, .size24)
            }
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
            
            Spacer()
            
            transferButtonView()
        }
        .navigationDestination(item: $viewModel.transferResult) { route in
            feedbackView(route)
        }
    }
}

extension TransferScreenView {
    private func feedbackView(_ route: TransferScreenViewResultRoute) -> some View {
        ObsidianFeedbackView(
            route.feedbackViewStyle,
            title: "Sucesso"
        ) {
            handleTransferUIFeedback(route)
        }
        .presentationDetents([.large])
        .toolbar(.hidden)
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
    private func transferInputView() -> some View {
        ObsidianCreditInput(
            text: $viewModel.transferAmount,
            title: "Valor",
            unitLabel: "MeritusCredits",
            maxDigits: 10
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
        )
        .padding(.horizontal, .size16)
    }
}

extension TransferScreenView {
    private func transferButtonView() -> some View {
        ObsidianButton(
            "Transferir",
            style: .primary,
            isLoading: $viewModel.isLoading
        ) {
            await viewModel.didTapTransferButton()
        }
        .padding(.horizontal, .size16)
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
            AudioServicesPlaySystemSound(sucessSoundId)
        case .error:
            let errorSoundId: UInt32 = 1520
            feedbaackGenerator.notificationOccurred(.error)
            AudioServicesPlaySystemSound(errorSoundId)
        }
    }
}
