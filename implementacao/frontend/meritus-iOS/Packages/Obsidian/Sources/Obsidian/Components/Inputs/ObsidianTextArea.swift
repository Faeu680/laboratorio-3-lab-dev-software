//
//  ObsidianTextArea.swift
//  Obsidian
//
//  Created by Arthur Porto on 28/11/25.
//

import SwiftUI

public struct ObsidianTextArea: View {
    @Binding private var text: String
    @Binding private var isError: Bool
    @Binding private var errorMessage: String?
    @FocusState private var isFocused: Bool
    
    private let label: LocalizedStringKey
    private let placeholder: LocalizedStringKey
    private let minHeight: CGFloat
    private let maxHeight: CGFloat?
    
    // MARK: - Inits
    
    public init(
        text: Binding<String>,
        label: LocalizedStringKey,
        placeholder: LocalizedStringKey,
        minHeight: CGFloat = 120,
        maxHeight: CGFloat? = nil,
        isError: Binding<Bool> = .constant(false),
        errorMessage: Binding<String?> = .constant(nil)
    ) {
        self._text = text
        self.label = label
        self.placeholder = placeholder
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self._isError = isError
        self._errorMessage = errorMessage
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: .size8) {
            Text(label)
                .obsidianLabel()
                .foregroundColor(.gray)
            
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.gray.opacity(0.4))
                        .obsidianBody()
                        .padding(.size16)
                }
                
                TextEditor(text: $text)
                    .scrollContentBackground(.hidden)
                    .padding(.size16)
                    .frame(minHeight: minHeight)
                    .frame(maxHeight: maxHeight)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .font(.custom("Montserrat-SemiBold", size: 16))
                    .focused($isFocused)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        borderColor,
                        lineWidth: borderWidth
                    )
            )
            
            if isError, let errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundColor(.red)
                    .padding(.leading, .size4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var borderColor: Color {
        if isError {
            return .red
        }
        return isFocused ? .primary : .gray.opacity(0.3)
    }
    
    private var borderWidth: CGFloat {
        isError ? 2 : (isFocused ? 2 : 1)
    }
}
