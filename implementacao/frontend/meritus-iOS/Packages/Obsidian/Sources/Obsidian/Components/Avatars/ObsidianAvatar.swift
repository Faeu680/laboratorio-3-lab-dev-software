//
//  ObsidianAvatar.swift
//  Obsidian
//
//  Created by Arthur Porto on 17/11/25.
//

import SwiftUI

public struct ObsidianAvatar: View {
    private let initials: String
    private let size: CGFloat = 80
    private let backgroundColor = Color(red: 212/255, green: 175/255, blue: 55/255)
    
    public init(initials: String) {
        self.initials = initials
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)
            
            Circle()
                .stroke(Color.white.opacity(0.15), lineWidth: 3)
            
            Text(initials)
                .font(.system(size: size * 0.33, weight: .semibold))
                .foregroundColor(.black)
        }
        .frame(width: size, height: size)
    }
}
