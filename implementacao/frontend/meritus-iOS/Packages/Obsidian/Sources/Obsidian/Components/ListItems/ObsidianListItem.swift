//
//  ObsidianListItem.swift
//  Obsidian
//
//  Created by Arthur Porto on 17/11/25.
//

import SwiftUI

public struct ObsidianListItem: View {
    
    // MARK: - types
    
    public enum BorderStyle {
        case none
        case regular
        case dashed
    }
    
    // MARK: - Private Properties
    
    private let title: String
    private let subtitle: String?
    private let leading: AnyView?
    private let trailing: AnyView?
    private let badges: [AnyView]
    private let borderStyle: BorderStyle
    private var action: (@Sendable () async -> Void)?
    
    private var horizontalPadding: CGFloat {
        borderStyle == .none ? .zero : .size16
    }
    
    private var verticalPadding: CGFloat {
        borderStyle == .none ? .size4 : .size16
    }
    
    private var borderColor: Color {
        Color.secondary.opacity(0.25)
    }
    
    // MARK: - Inits
    
    public init<Content: View>(
        title: String,
        subtitle: String? = nil,
        leading: Content? = nil,
        trailing: Content? = nil,
        badges: [ObsidianBadge] = [],
        borderStyle: BorderStyle = .none,
        onTap action: (@Sendable () async -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.leading = leading.map { AnyView($0) }
        self.trailing = trailing.map { AnyView($0) }
        self.badges = badges.map { AnyView($0) }
        self.borderStyle = borderStyle
        self.action = action
    }
    
    public init<Leading: View, Trailing: View>(
        title: String,
        subtitle: String? = nil,
        leading: Leading? = nil,
        trailing: Trailing? = nil,
        badges: [ObsidianBadge] = [],
        borderStyle: BorderStyle = .none,
        onTap action: (@Sendable () async -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.leading = leading.map { AnyView($0) }
        self.trailing = trailing.map { AnyView($0) }
        self.badges = badges.map { AnyView($0) }
        self.borderStyle = borderStyle
        self.action = action
    }
    
    public init(
        title: String,
        subtitle: String? = nil,
        leading: AnyView? = nil,
        trailing: AnyView? = nil,
        badges: [ObsidianBadge] = [],
        borderStyle: BorderStyle = .none,
        onTap action: (@Sendable () async -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.leading = leading
        self.trailing = trailing
        self.badges = badges.map { AnyView($0) }
        self.borderStyle = borderStyle
        self.action = action
    }
    
    // MARK: - Body
    
    public var body: some View {
        HStack(spacing: .size16) {
            if let leading { leading }
            
            VStack(alignment: .leading, spacing: .size4) {
                Text(title)
                    .font(.obsidianBody.weight(.semibold))
                
                if let subtitle {
                    Text(subtitle)
                        .obsidianLabel()
                        .foregroundStyle(.secondary)
                }
                
                if !badges.isEmpty {
                    HStack(spacing: 8) {
                        ForEach(Array(badges.prefix(2).enumerated()), id: \.offset) { _, view in
                            view
                        }
                    }
                    .padding(.top, 2)
                }
            }
            
            Spacer()
            
            if let trailing { trailing }
        }
        .padding(.vertical, verticalPadding)
        .padding(.horizontal, horizontalPadding)
        .background(borderView)
        .contentShape(Rectangle())
        .if(action != nil) { view in
            Button(async: action) {
                view
            }
            .buttonStyle(.plain)
        }
    }
    
    @ViewBuilder
    private var borderView: some View {
        switch borderStyle {
        case .none:
            Color.clear
        case .regular:
            RoundedRectangle(cornerRadius: 12)
                .stroke(borderColor, lineWidth: 1.5)
        case .dashed:
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    borderColor,
                    style: StrokeStyle(lineWidth: 1.5, dash: [8, 4])
                )
        }
    }
}

// MARK: - Builders

public extension ObsidianListItem {
    func onTap(action: (@Sendable () async -> Void)?) -> Self {
        then{ $0.action = action }
    }
}
