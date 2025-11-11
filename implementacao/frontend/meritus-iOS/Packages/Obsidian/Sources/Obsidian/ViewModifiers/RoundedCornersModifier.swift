//
//  RoundedCornersModifier.swift
//  Obsidian
//
//  Created by Arthur Porto on 10/11/25.
//

import SwiftUI

struct RoundedCornersModifier: ViewModifier {
    let radius: CGFloat
    let corners: UIRectCorner

    func body(content: Content) -> some View {
        content
            .clipShape(
                RoundedCornersShape(radius: radius, corners: corners)
            )
    }
    
    private struct RoundedCornersShape: Shape {
        let radius: CGFloat
        let corners: UIRectCorner
        
        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            return Path(path.cgPath)
        }
    }
}
