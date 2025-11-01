//
//  ObsidianInput.swift
//  Obsidian
//
//  Created by Arthur Porto on 17/10/25.
//

import SwiftUI

public struct ObsidianInput: View {
    @Binding private var text: String
    @FocusState private var isFocused: Bool
    
    private let label: LocalizedStringKey
    private let placeholder: LocalizedStringKey
    private let keyboardType: UIKeyboardType
    
    public init(
        text: Binding<String>,
        label: String,
        placeholder: String,
        keyboardType : UIKeyboardType = .default
    ) {
        self._text = text
        self.label = LocalizedStringKey(label)
        self.placeholder = LocalizedStringKey(placeholder)
        self.keyboardType = keyboardType
    }
    
    public init(
        text: Binding<String>,
        label: LocalizedStringKey,
        placeholder: LocalizedStringKey,
        keyboardType : UIKeyboardType = .default
    ) {
        self._text = text
        self.label = label
        self.placeholder = placeholder
        self.keyboardType = keyboardType
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(label)
                .obsidianLabel()
                .foregroundColor(.gray)
            
            TextField(placeholder, text: $text)
                .obsidianFontSemiBold()
                .foregroundColor(.primary)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    isFocused ? Color.primary : Color.gray.opacity(0.3),
                                    lineWidth: isFocused ? 2 : 1
                                )
                        )
                )
                .textInputAutocapitalization(.never)
                .keyboardType(keyboardType)
                .autocorrectionDisabled()
                .focused($isFocused)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    @Previewable @State var email: String = ""
    
    VStack(spacing: 20) {
        ObsidianInput(
            text: $email,
            label: "EMAIL",
            placeholder: "seu@email.com",
            keyboardType: .emailAddress
        )
        
        ObsidianInput(
            text: $email,
            label: "Senha",
            placeholder: "seu@email.com"
        )
    }
    .padding()
}
