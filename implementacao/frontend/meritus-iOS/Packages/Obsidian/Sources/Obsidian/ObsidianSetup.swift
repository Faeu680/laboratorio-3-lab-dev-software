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
        setupNavigationAppearance()
    }
    
    private static func setupFonts() {
        ObsidianFont.registerFonts()
    }
    
    private static func setupNavigationAppearance() {
        let appearance = UINavigationBarAppearance.montserratAppearance()
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
