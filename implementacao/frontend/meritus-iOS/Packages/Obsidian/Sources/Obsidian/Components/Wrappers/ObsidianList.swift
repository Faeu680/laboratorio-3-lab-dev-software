//
//  ObsidianList.swift
//  Obsidian
//
//  Created by Arthur Porto on 17/11/25.
//

import SwiftUI

public struct ObsidianList<Content: View>: View {
    private let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        List {
            content()
                .listRowSeparator(.hidden)
                .listRowInsets(
                    EdgeInsets(
                        top: .zero,
                        leading: .size16,
                        bottom: .zero,
                        trailing: .size16
                    )
                )
        }
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        .listSectionSpacing(0)
    }
}
