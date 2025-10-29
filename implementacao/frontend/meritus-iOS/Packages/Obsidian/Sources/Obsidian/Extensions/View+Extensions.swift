//
//  View+Extensions.swift
//  Obsidian
//
//  Created by Arthur Porto on 29/10/25.
//

import SwiftUI

public extension View {
    func onViewDidLoad(perform action: @escaping () -> Void) -> some View {
        modifier(ViewDidLoadModifier(action: action))
    }
}
