//
//  TransferScreenView.swift
//  Meritus
//
//  Created by Arthur Porto on 03/11/25.
//

import SwiftUI
import Obsidian

struct TransferScreenView: View {
    
    @StateObject private var viewModel: TransferScreenViewModel
    
    init(viewModel: TransferScreenViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            ForEach(0..<10, id: \.self) { index in
                userListItemView()
            }
        }
        .navigationTitle("Transferências")
        .navigationSubtitle("Selecione um aluno para realizar uma transferência")
        .toolbarTitleDisplayMode(.inlineLarge)
        
    }
}

extension TransferScreenView {
    private func userListItemView() -> some View {
        UserListItem(
            name: "Ana Silva",
            email: "ana.silva@email.com"
        )
    }
}
