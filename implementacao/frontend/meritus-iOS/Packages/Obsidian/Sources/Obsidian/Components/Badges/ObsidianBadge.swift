//
//  ObsidianBadge.swift
//  Obsidian
//
//  Created by Arthur Porto on 24/11/25.
//

import SwiftUI

public struct ObsidianBadge: View {

    // MARK: - Types

    public enum Style {
        case primary
        case secondary
        case outline
    }

    // MARK: - Properties

    private let title: String
    private let icon: String?
    private let style: Style

    // MARK: - Init

    public init(
        _ title: String,
        icon: String? = nil,
        style: Style = .primary
    ) {
        self.title = title
        self.icon = icon
        self.style = style
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: .size4) {
            if let icon {
                Image(systemName: icon)
            }
            
            Text(title)
                .obsidianLabel()
        }
        .padding(.horizontal, .size8)
        .padding(.vertical, .size4)
        .foregroundStyle(foregroundColor)
        .background(background)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(borderColor, lineWidth: style == .outline ? 1 : 0)
        )
    }

    // MARK: - Colors

    private var foregroundColor: Color {
        switch style {
        case .primary:
            return .white.opacity(0.9)
        case .secondary:
            return .primary
        case .outline:
            return .primary
        }
    }

    private var background: some View {
        switch style {
        case .primary:
            return Color.accentColor.opacity(0.90)
        case .secondary:
            return Color.secondary.opacity(0.12)
        case .outline:
            return Color.clear
        }
    }

    private var borderColor: Color {
        switch style {
        case .outline:
            return Color.secondary.opacity(0.35)
        default:
            return .clear
        }
    }
}
