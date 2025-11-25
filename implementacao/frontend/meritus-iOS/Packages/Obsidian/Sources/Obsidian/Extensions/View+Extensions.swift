//
//  View+Extensions.swift
//  Obsidian
//
//  Created by Arthur Porto on 29/10/25.
//

import SwiftUI

public extension View {
    func onAppear(perform action: @escaping () async -> Void) -> some View {
        modifier(AsyncViewOnAppearModifier(action: action))
    }
    
    func onViewDidLoad(perform action: @escaping () -> Void) -> some View {
        modifier(ViewDidLoadModifier(action: action))
    }
    
    func onViewDidLoad(perform action: @escaping () async -> Void) -> some View {
        modifier(ViewDidLoadModifier(action: action))
    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        modifier(RoundedCornersModifier(radius: radius, corners: corners))
    }
    
    func orEmptyView(_ condition: Bool) -> some View {
        modifier(OrEmptyViewModifier(condition))
    }
    
    func `if`<Modified: View>(_ condition: Bool, transform: @escaping (Self) -> Modified) -> some View {
        modifier(IfViewModifier(base: self, condition: condition, transform: transform))
    }
    
    @inlinable
    func then(_ block: (inout Self) -> Void) -> Self {
        var copy = self
        block(&copy)
        return copy
    }
}
