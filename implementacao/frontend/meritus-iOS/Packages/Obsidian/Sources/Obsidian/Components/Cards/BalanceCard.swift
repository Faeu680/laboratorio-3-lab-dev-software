//
//  BalanceCard.swift
//  Obsidian
//
//  Created by Arthur Porto on 03/11/25.
//

import SwiftUI

public struct BalanceCard: View {
    private let title: LocalizedStringKey
    private let amount: String
    private let showsEyeButton: Bool
    private let onToggleMask: ((Bool) -> Void)?

    @State private var isMasked: Bool

    public init(
        title: LocalizedStringKey,
        amount: String,
        initiallyMasked: Bool = false,
        showsEyeButton: Bool = true,
        onToggleMask: ((Bool) -> Void)? = nil
    ) {
        self.title = title
        self.amount = amount
        self._isMasked = State(initialValue: initiallyMasked)
        self.showsEyeButton = showsEyeButton
        self.onToggleMask = onToggleMask
    }

    public var body: some View {
        ZStack(alignment: .topLeading) {
            backgroundView
            content
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
        .frame(maxWidth: .infinity)
        .frame(height: 180)
    }
}

// MARK: - Content

private extension BalanceCard {
    var content: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: .size8) {
                HStack(spacing: .size8) {
                    Text(title)
                        .obsidianLabel()
                        .foregroundStyle(.gray)
                }

                amountView
            }

            Spacer()

            if showsEyeButton {
                Button(action: toggleMask) {
                    Image(systemName: isMasked ? "eye" : "eye.slash")
                        .foregroundStyle(.secondary)
                        .imageScale(.large)
                        .padding(8)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.size16)
    }

    var amountView: some View {
        Group {
            if isMasked {
                Text("••••••••")
                    .obsidianTitle()
            } else {
                Text(amount)
                    .obsidianTitle()
            }
        }
        .lineLimit(1)
    }
}

// MARK: - Background

private extension BalanceCard {
    var backgroundView: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.black.opacity(0.0),
                    Color.black.opacity(0.2)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            RadialGradient(
                gradient: Gradient(colors: [
                    Color.orange.opacity(0.18),
                    Color.clear
                ]),
                center: .topTrailing,
                startRadius: 20,
                endRadius: 260
            )
        }
    }
}

// MARK: - Actions

private extension BalanceCard {
    func toggleMask() {
        isMasked.toggle()
        onToggleMask?(isMasked)
    }
}
