//
//  ObsidianSelectIndicator.swift
//  Obsidian
//
//  Created by Arthur Porto on 18/11/25.
//

import SwiftUI

public struct ObsidianSelectIndicator: View {
    @Binding private var isSelected: Bool
    
    private let size: CGFloat = 24
    private let color: Color = Color(red: 212/255, green: 175/255, blue: 55/255)

    public init(isSelected: Binding<Bool>) {
        self._isSelected = isSelected
    }
    
    public init(isSelected: Bool) {
        self._isSelected = .constant(isSelected)
    }

    public var body: some View {
        ZStack {
            Circle()
                .fill(color)
                .frame(width: size, height: size)
            
            if isSelected {
                Image(systemName: "checkmark")
                    .font(.system(size: size * 0.55, weight: .bold))
                    .foregroundColor(.black)
            }
        }
        .animation(.easeOut(duration: 0.15), value: isSelected)
    }
}
