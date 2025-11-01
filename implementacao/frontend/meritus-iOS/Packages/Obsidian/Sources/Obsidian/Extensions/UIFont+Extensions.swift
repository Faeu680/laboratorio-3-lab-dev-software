//
//  UIFont+Extensions.swift
//  Obsidian
//
//  Created by Arthur Porto on 01/11/25.
//

import UIKit

import UIKit

extension UIFont {
    enum Montserrat {
        static func regular(_ size: CGFloat) -> UIFont {
            UIFont(name: "Montserrat-Regular", size: size)
                ?? UIFont.systemFont(ofSize: size, weight: .regular)
        }

        static func italic(_ size: CGFloat) -> UIFont {
            UIFont(name: "Montserrat-Italic", size: size)
                ?? UIFont.italicSystemFont(ofSize: size)
        }

        static func semiBold(_ size: CGFloat) -> UIFont {
            UIFont(name: "Montserrat-SemiBold", size: size)
                ?? UIFont.systemFont(ofSize: size, weight: .semibold)
        }

        static func semiBoldItalic(_ size: CGFloat) -> UIFont {
            UIFont(name: "Montserrat-SemiBoldItalic", size: size)
                ?? UIFont.systemFont(ofSize: size, weight: .semibold)
        }

        static func bold(_ size: CGFloat) -> UIFont {
            UIFont(name: "Montserrat-Bold", size: size)
                ?? UIFont.systemFont(ofSize: size, weight: .bold)
        }

        static func boldItalic(_ size: CGFloat) -> UIFont {
            UIFont(name: "Montserrat-BoldItalic", size: size)
                ?? UIFont.systemFont(ofSize: size, weight: .bold)
        }
    }
}
