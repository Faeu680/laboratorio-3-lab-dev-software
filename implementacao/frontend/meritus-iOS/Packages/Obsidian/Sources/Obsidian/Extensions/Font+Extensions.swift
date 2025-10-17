//
//  Font+Extensions.swift
//  Obsidian
//
//  Created by Arthur Porto on 15/10/25.
//


import SwiftUI

extension Font {
    
    // MARK: - Semantic Styles
    
    /// Large title MERITUS style (light, spaced)
    static var obsidianTitle: Font {
        return .obsidianRegular(size: 48)
    }
    
    /// Medium headline
    static var obsidianHeadline: Font {
        return .obsidianSemiBold(size: 32)
    }
    
    /// Subheadline
    static var obsidianSubheadline: Font {
        return .obsidianRegular(size: 20)
    }
    
    /// Body text
    static var obsidianBody: Font {
        return .obsidianRegular(size: 16)
    }
    
    /// Small text (labels)
    static var obsidianCaption: Font {
        return .obsidianRegular(size: 12)
    }
    
    /// Button text (uppercase, spaced)
    static var obsidianButton: Font {
        return .obsidianSemiBold(size: 14)
    }
    
    // MARK: - Regular
    
    /// Montserrat Regular
    private static func obsidianRegular(size: CGFloat) -> Font {
        return .custom("Montserrat-Regular", size: size)
    }
    
    /// Montserrat Italic
    private static func obsidianItalic(size: CGFloat) -> Font {
        return .custom("Montserrat-Italic", size: size)
    }
    
    // MARK: - SemiBold
    
    /// Montserrat SemiBold
    private static func obsidianSemiBold(size: CGFloat) -> Font {
        return .custom("Montserrat-SemiBold", size: size)
    }
    
    /// Montserrat SemiBold Italic
    private static func obsidianSemiBoldItalic(size: CGFloat) -> Font {
        return .custom("Montserrat-SemiBoldItalic", size: size)
    }
    
    // MARK: - Bold
    
    /// Montserrat Bold
    private static func obsidianBold(size: CGFloat) -> Font {
        return .custom("Montserrat-Bold", size: size)
    }
    
    /// Montserrat Bold Italic
    private static func obsidianBoldItalic(size: CGFloat) -> Font {
        return .custom("Montserrat-BoldItalic", size: size)
    }
}
