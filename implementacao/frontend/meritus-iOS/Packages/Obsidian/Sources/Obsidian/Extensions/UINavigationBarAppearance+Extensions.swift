//
//  UINavigationBarAppearance+Extensions.swift
//  Obsidian
//
//  Created by Arthur Porto on 01/11/25.
//

import UIKit

extension UINavigationBarAppearance {
    static func montserratAppearance() -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()

        appearance.largeTitleTextAttributes = [
            .font: UIFont.Montserrat.bold(34),
            .foregroundColor: UIColor.label
        ]
        appearance.titleTextAttributes = [
            .font: UIFont.Montserrat.semiBold(18),
            .foregroundColor: UIColor.label
        ]
        
        return appearance
    }
}
