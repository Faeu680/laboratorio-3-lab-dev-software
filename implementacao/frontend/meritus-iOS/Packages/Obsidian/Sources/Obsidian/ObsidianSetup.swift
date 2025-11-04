//
//  ObsidianSetup.swift
//  Obsidian
//
//  Created by Arthur Porto on 01/11/25.
//

import UIKit
import SwiftUI

@MainActor
public struct ObsidianSetup {
    
    public static func setup() {
        setupFonts()
        setupNavigationBarAppearance()
        setupTabBarAppearance()
    }
    
    private static func setupFonts() {
        ObsidianFont.registerFonts()
    }
    
    private static func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance.montserratAppearance()
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    private static func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        let gold = UIColor(red: 212/255, green: 175/255, blue: 55/255, alpha: 1.0)
        
        UITabBar.appearance().tintColor = gold
        UITabBar.appearance().unselectedItemTintColor = gold.withAlphaComponent(0.6)
        
        appearance.stackedLayoutAppearance.normal.iconColor = gold.withAlphaComponent(0.6)
        appearance.stackedLayoutAppearance.selected.iconColor = gold
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.Montserrat.regular(12),
            .foregroundColor: UIColor.label
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.Montserrat.regular(12),
            .foregroundColor: gold
        ]
        
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
