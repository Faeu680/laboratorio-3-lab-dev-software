//
//  LocalizedStringKey+Extensions.swift
//  Obsidian
//
//  Created by Arthur Porto on 02/11/25.
//

import SwiftUI

public extension LocalizedStringKey {
    var localized: String {
        let mirror = Mirror(reflecting: self)
        guard let key = mirror.children.first(where: { $0.label == "key" })?.value as? String else {
            return ""
        }
        return NSLocalizedString(key, comment: "")
    }
}
