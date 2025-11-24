//
//  AsyncViewOnAppearModifier.swift
//  Obsidian
//
//  Created by Arthur Porto on 23/11/25.
//

import SwiftUI

struct AsyncViewOnAppearModifier: ViewModifier {
    private let action: () async -> Void
    
    init(action: @escaping () async -> Void) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                Task(priority: .userInitiated) {
                    await action()
                }
            }
    }
}
