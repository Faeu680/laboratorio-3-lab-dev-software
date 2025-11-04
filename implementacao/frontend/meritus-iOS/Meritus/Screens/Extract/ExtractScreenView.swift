//
//  ExtractScreenView.swift
//  Meritus
//
//  Created by Arthur Porto on 03/11/25.
//

import SwiftUI
import Obsidian

struct ExtractScreenView: View {
    
    @StateObject private var viewModel: ExtractScreenViewModel

    init(viewModel: ExtractScreenViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            balanceCardView()
            
            // Professor / Aluno
            ForEach(0..<10, id: \.self) { index in
                transactionListItemView()
            }
        }
        .scrollIndicators(.never)
    }
}

extension ExtractScreenView {
    private func balanceCardView() -> some View {
        BalanceCard(
            title: "Saldo Disponível",
            amount: 125_430.50,
            initiallyMasked: true
        )
        .padding(.horizontal, .size16)
    }
}

extension ExtractScreenView {
    private func transactionListItemView() -> some View {
        TransactionListItem(
            title: "Mercado",
            subtitle: "Despesa",
            amount: 350.89,
            kind: .expense,
            date: .now
        )
        .padding(.horizontal, .size16)
    }
}
