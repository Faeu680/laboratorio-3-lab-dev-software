//
//  ObsidianList.swift
//  Obsidian
//
//  Created by Arthur Porto on 17/11/25.
//

import SwiftUI

public struct ObsidianList<Content: View>: View {
    private let horizontalPadding: CGFloat
    private let verticalPadding: CGFloat
    private let content: () -> Content

    public init(
        horizontalPadding: CGFloat = .size16,
        verticalPadding: CGFloat = .zero,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.content = content
    }

    public var body: some View {
        List {
            content()
                .listRowSeparator(.hidden)
                .listRowInsets(
                    EdgeInsets(
                        top: verticalPadding,
                        leading: horizontalPadding,
                        bottom: verticalPadding,
                        trailing: horizontalPadding
                    )
                )
        }
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        .listSectionSpacing(0)
    }
}
