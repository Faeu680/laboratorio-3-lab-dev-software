//
//  ObsidianSection.swift
//  Obsidian
//
//  Created by Arthur Porto on 24/11/25.
//

import SwiftUI

public struct ObsidianSection<Header: View, Content: View>: View {
    private let header: () -> Header
    private let content: () -> Content

    public init(
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.header = header
        self.content = content
    }
    
    public init(
        header: Header,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.header = { header }
        self.content = content
    }

    public init(
        @ViewBuilder content: @escaping () -> Content
    ) where Header == EmptyView {
        self.header = { EmptyView() }
        self.content = content
    }

    public var body: some View {
        Section {
            content()
        } header: {
            header()
        }
        .listSectionSeparator(.hidden)
        .background(Color.clear)
    }
}
