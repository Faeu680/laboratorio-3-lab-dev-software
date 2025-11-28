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
    @State private var isFocused: Bool = false

    private let label: LocalizedStringKey
    private let placeholder: LocalizedStringKey
    private let minHeight: CGFloat
    private let maxHeight: CGFloat?
    private let onFocusChanged: ((Bool) -> Void)?
    
    // MARK: - Inits
    
    public init(
        text: Binding<String>,
        label: LocalizedStringKey,
        placeholder: LocalizedStringKey,
        minHeight: CGFloat = 120,
        maxHeight: CGFloat? = nil,
        isError: Binding<Bool> = .constant(false),
        errorMessage: Binding<String?> = .constant(nil),
        onFocusChanged: ((Bool) -> Void)? = nil
    ) {
        self._text = text
        self.label = label
        self.placeholder = placeholder
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self._isError = isError
        self._errorMessage = errorMessage
        self.onFocusChanged = onFocusChanged
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
                
                TextViewWithToolbar(
                    text: $text,
                    isFocused: $isFocused
                )
                .frame(minHeight: minHeight)
                .frame(maxHeight: maxHeight)
                .onChange(of: isFocused) { focused in
                    onFocusChanged?(focused)
                }
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
    
    private struct TextViewWithToolbar: UIViewRepresentable {
        @Binding var text: String
        @Binding var isFocused: Bool
        
        func makeUIView(context: Context) -> UITextView {
            let tv = UITextView()
            tv.font = UIFont(name: "Montserrat-SemiBold", size: 16)
            tv.backgroundColor = .clear
            tv.delegate = context.coordinator
            tv.isScrollEnabled = true
            tv.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

            let toolbar = UIToolbar()
            toolbar.sizeToFit()

            let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

            let doneButton = UIBarButtonItem(
                barButtonSystemItem: .done,
                target: context.coordinator,
                action: #selector(Coordinator.dismissKeyboard)
            )

            toolbar.items = [flex, doneButton]

            tv.inputAccessoryView = toolbar

            NotificationCenter.default.addObserver(
                context.coordinator,
                selector: #selector(Coordinator.keyboardWillHide),
                name: UIResponder.keyboardWillHideNotification,
                object: nil
            )

            return tv
        }

        func updateUIView(_ uiView: UITextView, context: Context) {
            if uiView.text != text {
                uiView.text = text
            }

            DispatchQueue.main.async {
                if isFocused && !uiView.isFirstResponder {
                    uiView.becomeFirstResponder()
                } else if !isFocused && uiView.isFirstResponder {
                    uiView.resignFirstResponder()
                }
            }
        }

        func makeCoordinator() -> Coordinator {
            Coordinator(text: $text, isFocused: $isFocused)
        }

        static func dismantleUIView(_ uiView: UITextView, coordinator: Coordinator) {
            NotificationCenter.default.removeObserver(coordinator)
        }

        final class Coordinator: NSObject, UITextViewDelegate {
            @Binding var text: String
            @Binding var isFocused: Bool

            init(text: Binding<String>, isFocused: Binding<Bool>) {
                self._text = text
                self._isFocused = isFocused
            }

            @objc func dismissKeyboard() {
                isFocused = false
            }

            @objc func cancelEditing() {
                isFocused = false
            }

            @objc func keyboardWillHide() {
                isFocused = false
            }

            func textViewDidChange(_ textView: UITextView) {
                text = textView.text
            }

            func textViewDidBeginEditing(_ textView: UITextView) {
                isFocused = true
            }
        }
    }
}
