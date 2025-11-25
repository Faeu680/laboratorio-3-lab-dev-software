//
//  IfViewModifier.swift
//  Obsidian
//
//  Created by Arthur Porto on 24/11/25.
//

import SwiftUI

struct IfViewModifier<Base: View, Modified: View>: ViewModifier {
    private let condition: Bool
    private let transform: (Base) -> Modified
    private let base: Base

    init(
        base: Base,
        condition: Bool,
        transform: @escaping (Base) -> Modified
    ) {
        self.base = base
        self.condition = condition
        self.transform = transform
    }
    
    func body(content: Content) -> some View {
        Group {
            if condition {
                transform(base)
            } else {
                base
            }
        }
    }
}
