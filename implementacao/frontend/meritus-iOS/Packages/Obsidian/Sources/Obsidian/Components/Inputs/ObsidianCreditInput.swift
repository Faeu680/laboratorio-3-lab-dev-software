//
//  ObsidianCreditInput.swift
//  Obsidian
//
//  Created by Arthur Porto on 25/11/25.
//

import SwiftUI

public struct ObsidianCreditInput: View {
    @Binding private var text: String
    @State private var isFocused: Bool = false
    
    private let title: LocalizedStringKey
    private let unitLabel: LocalizedStringKey
    private let maxDigits: Int = 7
    
    public init(
        text: Binding<String>,
        title: LocalizedStringKey,
        unitLabel: LocalizedStringKey
    ) {
        self._text = text
        self.title = title
        self.unitLabel = unitLabel
    }
    
    public var body: some View {
        VStack(spacing: .size8) {
            Text(title)
                .obsidianLabel()
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(displayText)
                .obsidianTitle()
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .center)
                .contentShape(Rectangle())
            
            LinearGradient(
                colors: [
                    Color(red: 0.90, green: 0.78, blue: 0.30),
                    Color(red: 0.80, green: 0.60, blue: 0.15)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(height: 2)
            .cornerRadius(2)
            .padding(.horizontal, .size48)
            
            Text(unitLabel)
                .obsidianLabel()
                .foregroundColor(.secondary)
        }
        .onTapGesture { isFocused = true }
        .overlay {
            NumericTextFieldWithToolbar(
                text: $text,
                isFocused: $isFocused,
                maxDigits: maxDigits
            )
        }
    }
    
    private var displayText: String {
        text.isEmpty ? "0" : text
    }
    
    private struct NumericTextFieldWithToolbar: UIViewRepresentable {
        @Binding var text: String
        @Binding var isFocused: Bool
        let maxDigits: Int
        
        func makeUIView(context: Context) -> UITextField {
            let textField = UITextField()
            textField.keyboardType = .numberPad
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .none
            textField.delegate = context.coordinator
            
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            
            let flexSpace = UIBarButtonItem(
                barButtonSystemItem: .flexibleSpace,
                target: nil,
                action: nil
            )
            
            let doneButton = UIBarButtonItem(
                barButtonSystemItem: .close,
                target: context.coordinator,
                action: #selector(Coordinator.dismissKeyboard)
            )
            
            toolbar.items = [flexSpace, doneButton]
            
            let containerView = UIView()
            containerView.addSubview(toolbar)
            toolbar.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                toolbar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                toolbar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                toolbar.topAnchor.constraint(equalTo: containerView.topAnchor),
                toolbar.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
            ])
            
            let toolbarHeight = toolbar.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            containerView.frame = CGRect(x: 0, y: 0, width: 0, height: toolbarHeight + 16)
            
            textField.inputAccessoryView = containerView
            textField.alpha = 0.01
            textField.isUserInteractionEnabled = true
            
            // Adicionar observers para notificações do teclado
            NotificationCenter.default.addObserver(
                context.coordinator,
                selector: #selector(Coordinator.keyboardWillHide),
                name: UIResponder.keyboardWillHideNotification,
                object: nil
            )
            
            return textField
        }
        
        func updateUIView(_ uiView: UITextField, context: Context) {
            uiView.text = text
            
            DispatchQueue.main.async {
                if isFocused && !uiView.isFirstResponder {
                    uiView.becomeFirstResponder()
                } else if !isFocused && uiView.isFirstResponder {
                    uiView.resignFirstResponder()
                }
            }
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(text: $text, isFocused: $isFocused, maxDigits: maxDigits)
        }
        
        static func dismantleUIView(_ uiView: UITextField, coordinator: Coordinator) {
            // Remover observers quando a view for destruída
            NotificationCenter.default.removeObserver(
                coordinator,
                name: UIResponder.keyboardWillHideNotification,
                object: nil
            )
        }
        
        final class Coordinator: NSObject, UITextFieldDelegate {
            @Binding var text: String
            @Binding var isFocused: Bool
            let maxDigits: Int
            
            init(text: Binding<String>, isFocused: Binding<Bool>, maxDigits: Int) {
                self._text = text
                self._isFocused = isFocused
                self.maxDigits = maxDigits
            }
            
            @objc func dismissKeyboard() {
                isFocused = false
            }
            
            @objc func keyboardWillHide() {
                // Atualizar o estado quando o teclado for fechado por scroll
                if isFocused {
                    isFocused = false
                }
            }
            
            func textField(
                _ textField: UITextField,
                shouldChangeCharactersIn range: NSRange,
                replacementString string: String
            ) -> Bool {
                let currentText = textField.text ?? ""
                guard let stringRange = Range(range, in: currentText) else { return false }
                
                let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
                let digitsOnly = updatedText.filter { $0.isNumber }
                let limited = String(digitsOnly.prefix(maxDigits))
                
                text = limited
                textField.text = limited
                
                return false
            }
        }
    }
}
