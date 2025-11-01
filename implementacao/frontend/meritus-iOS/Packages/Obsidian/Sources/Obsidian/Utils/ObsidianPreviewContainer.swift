//
//  ObsidianPreviewContainer.swift
//  Obsidian
//
//  Created by Arthur Porto on 15/10/25.
//

import SwiftUI

public struct ObsidianPreviewContainer<Content: View>: View {
    
    private let content: Content
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        ObsidianFont.registerFonts()
    }
    
    public var body: some View {
        NavigationStack {
            content
        }
    }
}
