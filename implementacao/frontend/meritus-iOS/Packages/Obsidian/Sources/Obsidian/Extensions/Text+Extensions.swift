//
//  Text+Extensions.swift
//  Obsidian
//
//  Created by Arthur Porto on 15/10/25.
//

import SwiftUI

public extension Text {
    func meritusTitle() -> some View {
        self
            .font(.obsidianTitle)
            .tracking(8)
            .textCase(.uppercase)
    }
    
    func obsidianLabel() -> some View {
        self
            .font(.obsidianCaption)
            .tracking(1.5)
            .textCase(.uppercase)
    }
    
    func obsidianBody() -> some View {
        self
            .font(.obsidianBody)
    }
    
    func obsidianButton() -> some View {
        self
            .font(.obsidianButton)
            .tracking(2)
            .textCase(.uppercase)
    }
}
