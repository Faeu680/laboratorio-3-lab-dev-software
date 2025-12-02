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
        ObsidianList(verticalPadding: .size8) {
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
        .onAppear {
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
        ObsidianListItem(
            title: transaction.message,
            subtitle: transaction.createdAt.shortBRDate,
            leading: leadingListItemView(transaction),
            trailing: trailingListItemView(transaction)
        )
    }
}

extension ExtractScreenView {
    private func leadingListItemView(_ transaction: TransactionModel) -> some View {
        ZStack {
            Circle()
                .fill(transaction.origin == .income ? Color.obsidianGold.opacity(0.18) : Color.red.opacity(0.18))
            
            Image(systemName: transaction.origin == .income ? "arrow.down.left" : "arrow.up.right")
                .foregroundStyle(transaction.origin == .income ? Color.obsidianGold : Color.red)
                .font(.system(size: 16, weight: .semibold))
        }
        .frame(width: 44, height: 44)
    }
}

extension ExtractScreenView {
    private func trailingListItemView(_ transaction: TransactionModel) -> some View {
        Text(transaction.amount)
            .obsidianBody()
            .foregroundStyle(transaction.origin == .income ? Color.obsidianGold : Color.red.opacity(0.9))
            .lineLimit(1)
    }
}

fileprivate extension String {
    var shortBRDate: String {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = f.date(from: self) else { return self }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "d 'de' MMM"
        return formatter.string(from: date).uppercased()
    }
}
