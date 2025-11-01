//
//  ObsidianFont.swift
//  Obsidian
//
//  Created by Arthur Porto on 15/10/25.
//

import SwiftUI
import CoreText

public enum ObsidianFont {
    static func registerFonts() {
        let fontNames = [
            "Montserrat-Regular",
            "Montserrat-Italic",
            "Montserrat-SemiBold",
            "Montserrat-SemiBoldItalic",
            "Montserrat-Bold",
            "Montserrat-BoldItalic"
        ]

        for name in fontNames {
            registerFont(named: name, withExtension: "ttf")
        }
    }

    private static func registerFont(named name: String, withExtension ext: String) {
        guard let url = Bundle.module.url(forResource: name, withExtension: ext) else {
            print("Failed to find font file: \(name)")
            return
        }

        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error) {
            let message = error?.takeUnretainedValue().localizedDescription ?? "unknown error"
            print("Could not register font \(name): \(message)")
        } else {
            print("Registered font: \(name)")
        }
    }
}
