//
//  SheetContainer.swift
//  Obsidian
//
//  Created by Arthur Porto on 07/11/25.
//

import SwiftUI

public struct SheetContainer<Content: View>: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets: EdgeInsets
    @State private var contentHeight: CGFloat = 0
    
    private let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        content
            .padding(.bottom, safeAreaInsets.bottom > 0 ? 0 : .size16)
            .presentationDetents([.height(contentHeight)])
            .onGeometryChange(for: CGSize.self) { proxy in
                proxy.size
            } action: { size in
                contentHeight = size.height
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}
