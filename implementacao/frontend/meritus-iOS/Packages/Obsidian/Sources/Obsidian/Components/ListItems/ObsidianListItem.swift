//
//  ObsidianListItem.swift
//  Obsidian
//
//  Created by Arthur Porto on 17/11/25.
//

import SwiftUI

public struct ObsidianListItem: View {
    
    // MARK: - Private Properties
    
    private let title: String
    private let subtitle: String?
    private let leading: AnyView?
    private let trailing: AnyView?
    
    // MARK: - Init
    
    public init<Content: View>(
        title: String,
        subtitle: String? = nil,
        leading: Content? = nil,
        trailing: Content? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.leading = leading.map { AnyView($0) }
        self.trailing = trailing.map { AnyView($0) }
    }
    
    public init(
        title: String,
        subtitle: String? = nil,
        leading: AnyView? = nil,
        trailing: AnyView? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.leading = leading
        self.trailing = trailing
    }
    
    // MARK: - Body
    
    public var body: some View {
        HStack(spacing: .size16) {
            if let leading { leading }
            
            VStack(alignment: .leading, spacing: .size4) {
                Text(title)
                    .font(.obsidianBody.weight(.semibold))
                
                if let subtitle {
                    Text(subtitle)
                        .obsidianLabel()
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            if let trailing { trailing }
        }
        .padding(.vertical, .size4)
    }
}
