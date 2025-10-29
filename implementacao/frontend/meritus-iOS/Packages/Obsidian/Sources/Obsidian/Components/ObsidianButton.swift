//
//  ObsidianButton.swift
//  Obsidian
//
//  Created by Arthur Porto on 15/10/25.
//

import SwiftUI

public struct ObsidianButton: View {
    
    // MARK: - Button Style Enum

    public enum Style {
        case primary
        case secondary
        case outline
    }
    
    // MARK: Binding Properties
    
    @Binding private var isLoading: Bool
    @Binding private var isDisabled: Bool
    
    // MARK: Private Properties
    
    private let title: String
    private let style: Style
    private let action: () -> Void
    
    // MARK: Initialization
    
    public init(
        _ title: String,
        style: Style = .primary,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self._isLoading = .constant(false)
        self._isDisabled = .constant(false)
        self.action = action
    }
    
    public init(
        _ title: String,
        style: Style = .primary,
        isLoading: Binding<Bool> = .constant(false),
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self._isLoading = isLoading
        self._isDisabled = .constant(false)
        self.action = action
    }
    
    public init(
        _ title: String,
        style: Style = .primary,
        isDisabled: Binding<Bool> = .constant(false),
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self._isLoading = .constant(false)
        self._isDisabled = isDisabled
        self.action = action
    }
    
    // MARK: Body
    
    public var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: textColor))
                        .scaleEffect(0.8)
                } else {
                    Text(title)
                        .obsidianButton()
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(backgroundColor)
            .foregroundStyle(textColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .opacity(isDisabled || isLoading ? 0.5 : 1.0)
        }
        .disabled(isDisabled || isLoading)
    }
    
    // MARK: - Style Properties
    
    private var backgroundColor: Color {
        switch style {
        case .primary:
            return .primary
        case .secondary:
            return Color(.systemGray6)
        case .outline:
            return .clear
        }
    }
    
    private var textColor: Color {
        switch style {
        case .primary:
            return Color(.systemBackground)
        case .secondary:
            return .primary
        case .outline:
            return .primary
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .outline:
            return .primary
        default:
            return .clear
        }
    }
    
    private var borderWidth: CGFloat {
        style == .outline ? 1.5 : 0
    }
}

// MARK: - Preview

#Preview("Button Styles") {
    ObsidianPreview {
        VStack(spacing: 24) {
            // Primary
            ObsidianButton("SIGN IN", style: .primary) {
                print("Primary tapped")
            }
            
            // Secondary
            ObsidianButton("CANCEL", style: .secondary) {
                print("Secondary tapped")
            }
            
            // Outline
            ObsidianButton("REQUEST ACCESS", style: .outline) {
                print("Outline tapped")
            }
            
            Divider()
                .padding(.vertical)
            
            // Loading states
            ObsidianButton("LOADING", style: .primary, isLoading: .constant(true)) {
                print("Loading")
            }
            
            // Disabled
            ObsidianButton("DISABLED", style: .primary, isDisabled: .constant(true)) {
                print("Disabled")
            }
        }
        .padding()
    }
}
