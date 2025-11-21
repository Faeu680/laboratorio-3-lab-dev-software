//
//  TransferScreenView.swift
//  Meritus
//
//  Created by Arthur Porto on 03/11/25.
//

import SwiftUI
import Obsidian
import Domain
import Session

struct TransferScreenView: View {
    
    @StateObject private var viewModel: TransferScreenViewModel
    
    init(viewModel: TransferScreenViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ObsidianList(verticalPadding: .size8) {
            ForEach(viewModel.students, id: \.id) { student in
                userListItemView(student)
            }
        }
        .navigationTitle("Transferências")
        .navigationSubtitle("Selecione um aluno para realizar uma transferência")
        .toolbarTitleDisplayMode(.inlineLarge)
        .sheet(isPresented: $viewModel.showTransferModal) {
            transferModalView()
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
    }
}

extension TransferScreenView {
    private func transferModalView() -> some View {
        NavigationView {
            VStack {
                transferInputView()
                
                VStack(spacing: .size24) {
                    if let currentAccount = viewModel.storedSession {
                        selectedUserItemView(
                            sectionTitle: "De:",
                            isCurrentAccount: true,
                            name: currentAccount.name,
                            email: currentAccount.email
                        )
                    }
                    
                    if let destinationAccount = viewModel.selectedStudent {
                        selectedUserItemView(
                            sectionTitle: "Para:",
                            isCurrentAccount: false,
                            name: destinationAccount.name,
                            email: destinationAccount.email
                        )
                    }
                }
                .padding(.top, .size24)
                
                Spacer()
                
                transferButtonView()
            }
            .padding(.horizontal, .size16)
            .navigationTitle("Transferir")
            .toolbarTitleDisplayMode(.large)
            .presentationDetents([.large])
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
        }
    }
}

extension TransferScreenView {
    private func transferInputView() -> some View {
        ObsidianInput(
            text: $viewModel.transferAmount,
            label: "Valor",
            placeholder: "200"
        )
    }
}

extension TransferScreenView {
    private func transferButtonView() -> some View {
        ObsidianButton(
            "Transferir",
            style: .primary,
            isLoading: $viewModel.isLoading
        ) {
            Task(priority: .userInitiated) {
                await viewModel.didTapTransferButton()
            }
        }
    }
}
