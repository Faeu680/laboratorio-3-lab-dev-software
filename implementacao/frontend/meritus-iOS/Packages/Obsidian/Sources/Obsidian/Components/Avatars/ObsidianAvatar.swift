//
//  ObsidianAvatar.swift
//  Obsidian
//
//  Created by Arthur Porto on 17/11/25.
//

import SwiftUI

public struct ObsidianAvatar: View {
    
    // MARK: - Types
    
    public enum Size {
        case small
        case medium
        case large
        
        var value: CGFloat {
            switch self {
            case .small: return 32
            case .medium: return 56
            case .large: return 80
            }
        }
    }
    
    // MARK: - Private Properties
    
    private let initials: String
    private let size: Size
    private let backgroundColor = Color(red: 212/255, green: 175/255, blue: 55/255)
    
    private var borderColor: Color {
        Color.white.opacity(0.15)
    }
    
    // MARK: - Init
    
    public init(
        initials: String,
        size: Size = .large
    ) {
        self.initials = initials
        self.size = size
    }
    
    // MARK: - Body
    
    public var body: some View {
        let dimension = size.value
        
        ZStack {
            Circle()
                .fill(backgroundColor)
            
            Circle()
                .stroke(borderColor, lineWidth: 3)
            
            Text(initials)
                .font(.system(size: dimension * 0.33, weight: .semibold))
                .foregroundStyle(.black)
        }
        .frame(width: dimension, height: dimension)
    }
}
