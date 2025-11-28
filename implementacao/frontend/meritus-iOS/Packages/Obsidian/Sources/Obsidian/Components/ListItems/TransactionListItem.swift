//
//  TransactionListItem.swift
//  Obsidian
//
//  Created by Arthur Porto on 03/11/25.
//

import SwiftUI

public struct TransactionListItem: View {
    public enum Kind {
        case income
        case expense
    }
    
    private let id: UUID
    private let title: String
    private let subtitle: String
    private let amount: String
    private let kind: Kind
    private let date: Date

    public init(
        id: UUID = UUID(),
        title: String,
        subtitle: String,
        amount: String,
        kind: Kind,
        date: Date
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.amount = amount
        self.kind = kind
        self.date = date
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 12) {
                leadingIcon
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.obsidianBody.weight(.semibold))

                    HStack(spacing: 8) {
                        Text(kind == .income ? "Receita" : "Despesa")
                            .obsidianLabel()
                            .foregroundStyle(.secondary)

                        Text("•")
                            .foregroundStyle(.secondary)

                        Text(shortDate(date))
                            .obsidianLabel()
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                Text(amount)
                    .font(.obsidianBody.weight(.bold))
                    .foregroundStyle(kind == .income ? Color.obsidianGold : Color.red.opacity(0.9))
                    .multilineTextAlignment(.trailing)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
        }
    }

    // MARK: - Subviews

    private var leadingIcon: some View {
        ZStack {
            Circle()
                .fill(Color.obsidianGold.opacity(0.18))
            Image(systemName: kind == .income ? "arrow.down.left" : "arrow.up.right")
                .foregroundStyle(Color.obsidianGold)
                .font(.system(size: 16, weight: .semibold))
        }
        .frame(width: 44, height: 44)
    }
}

// MARK: - Helpers

private func shortDate(_ date: Date) -> String {
    let df = DateFormatter()
    df.locale = Locale(identifier: "pt_BR")
    df.setLocalizedDateFormatFromTemplate("d MMM")
    return df.string(from: date)
}
