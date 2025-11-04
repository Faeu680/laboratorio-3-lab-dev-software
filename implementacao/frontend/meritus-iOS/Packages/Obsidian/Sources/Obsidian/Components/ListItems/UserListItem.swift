//
//  UserListItem.swift
//  Obsidian
//
//  Created by Arthur Porto on 04/11/25.
//

import SwiftUI

private extension Color {
    static var obsidianGold: Color {
        Color(red: 212/255, green: 175/255, blue: 55/255)
    }
}

// MARK: - View

public struct UserListItem: View {
    private let id: UUID
    private let name: String
    private let email: String
    private let avatar: Image?

    public init(
        id: UUID = UUID(),
        name: String,
        email: String,
        avatar: Image? = nil
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.avatar = avatar
    }

    public var body: some View {
        content
    }

    private var content: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                leadingAvatar

                VStack(alignment: .leading, spacing: 6) {
                    Text(name)
                        .font(.obsidianBody.weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    Text(email)
                        .obsidianBody()
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer(minLength: 12)

                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
                    .imageScale(.medium)
            }
        }
    }

    private var leadingAvatar: some View {
        ZStack {
            Circle()
                .fill(Color.obsidianGold.opacity(0.18))

            if let avatar = avatar {
                avatar
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.crop.circle")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.obsidianGold)
            }
        }
        .frame(width: 44, height: 44)
        .overlay(
            Circle().stroke(Color.white.opacity(0.05), lineWidth: 0.5)
        )
    }
}

// MARK: - Preview

#Preview("UserListItem") {
    ObsidianPreviewContainer {
        VStack(spacing: 12) {
            UserListItem(
                name: "Ana Silva",
                email: "ana.silva@email.com"
            )

            UserListItem(
                name: "João Pereira",
                email: "joao.pereira@email.com"
            )
        }
    }
}
