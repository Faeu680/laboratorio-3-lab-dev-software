//
//  ExtractScreenView.swift
//  Meritus
//
//  Created by Arthur Porto on 03/11/25.
//

import SwiftUI
import Obsidian
import Domain

struct ExtractScreenView: View {
    
    @StateObject private var viewModel: ExtractScreenViewModel

    init(viewModel: ExtractScreenViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ObsidianList(
            verticalPadding: .size8
        ) {
            balanceCardView()
            
            ObsidianSection {
                Text("Extrato")
                    .obsidianBody()
            } content: {
                ForEach(viewModel.transactions, id: \.id) { transaction in
                    transactionListItemView(transaction)
                }
            }
        }
        .applyMeritusToolbarTitle()
        .onViewDidLoad {
            await viewModel.onViewDidLoad()
        }
    }
}

extension ExtractScreenView {
    @ViewBuilder
    private func balanceCardView() -> some View {
        if let balance = viewModel.balance {
            BalanceCard(
                title: "Saldo Disponível",
                amount: balance,
                initiallyMasked: true
            )
        }
    }
}

extension ExtractScreenView {
    private func transactionListItemView(_ transaction: TransactionModel) -> some View {
        TransactionListItem(
            title: "Alguma coisa",
            subtitle: "Alguma descrição",
            amount: transaction.amount,
            kind: transaction.origin.toTransactionKind(),
            date: .now
        )
    }
}

fileprivate extension TransactionOrigin {
    func toTransactionKind() -> TransactionListItem.Kind {
        switch self {
        case .income:
            return .income
        case .outcome:
            return .expense
        }
    }
}
