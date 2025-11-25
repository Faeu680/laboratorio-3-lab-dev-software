//
//  ObsidianCreditInput.swift
//  Obsidian
//
//  Created by Arthur Porto on 25/11/25.
//

import SwiftUI

public struct ObsidianCreditInput: View {
    @Binding private var text: String
    @FocusState private var isFocused: Bool
    
    private let title: LocalizedStringKey
    private let unitLabel: LocalizedStringKey
    private let maxDigits: Int
    
    public init(
        text: Binding<String>,
        title: LocalizedStringKey,
        unitLabel: LocalizedStringKey = "Meritus Credits",
        maxDigits: Int = 10
    ) {
        self._text = text
        self.title = title
        self.unitLabel = unitLabel
        self.maxDigits = maxDigits
    }
    
    public var body: some View {
        VStack(spacing: .size8) {
            Text(title)
                .obsidianLabel()
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(displayText)
                .font(.system(size: 64, weight: .bold, design: .default))
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .center)
                .contentShape(Rectangle())
                .onTapGesture { isFocused = true }
            
            LinearGradient(
                colors: [
                    Color(red: 0.90, green: 0.78, blue: 0.30),
                    Color(red: 0.80, green: 0.60, blue: 0.15)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(height: 4)
            .cornerRadius(2)
            .padding(.horizontal, .size32)
            
            Text(unitLabel)
                .obsidianLabel()
                .foregroundColor(.secondary)
        }
        .overlay {
            HiddenNumericField(
                text: $text,
                isFocused: _isFocused,
                maxDigits: maxDigits
            )
            .background(Color.red)
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Concluir") { isFocused = false }
            }
        }
    }
    
    private var displayText: String {
        text.isEmpty ? "0" : text
    }
}

// MARK: - Hidden field to capture numeric input
private struct HiddenNumericField: View {
    @Binding var text: String
    @FocusState var isFocused: Bool
    
    let maxDigits: Int
    
    var body: some View {
        // Mantém o campo fora de vista, mas focável
        TextField("", text: Binding(
            get: { text },
            set: { newValue in
                let digitsOnly = newValue.filter { $0.isNumber }
                let limited = String(digitsOnly.prefix(maxDigits))
                if limited != text { text = limited }
            }
        ))
        .keyboardType(.numberPad)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
        .focused($isFocused)
        .frame(width: 0, height: 0)
        .opacity(0.01)
        
    }
}

#Preview {
    @Previewable @State var amount: String = ""
    
    ObsidianPreviewContainer {
        VStack(spacing: .size24) {
            ObsidianCreditInput(text: $amount, title: "Valor")
        }
        .padding()
    }
}
