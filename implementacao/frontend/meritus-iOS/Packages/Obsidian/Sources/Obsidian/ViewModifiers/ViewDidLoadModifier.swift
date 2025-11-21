//
//  ViewDidLoadModifier.swift
//  Obsidian
//
//  Created by Arthur Porto on 29/10/25.
//

import SwiftUI

struct ViewDidLoadModifier: ViewModifier {
    @State private var didLoad = false
    private let action: () async -> Void
    
    init(action: @escaping () async -> Void) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if !didLoad {
                    didLoad = true
                    Task(priority: .userInitiated) {
                        await action()
                    }
                }
            }
    }
}
