//
//  OrEmptyViewModifier.swift
//  Obsidian
//
//  Created by Arthur Porto on 23/11/25.
//

import SwiftUI

struct OrEmptyViewModifier: ViewModifier {
    private let condition: Bool
    
    init(_ condition: Bool) {
        self.condition = condition
    }
    
    func body(content: Content) -> some View {
        if !condition {
            content
        } else {
            EmptyView()
        }
    }
}
