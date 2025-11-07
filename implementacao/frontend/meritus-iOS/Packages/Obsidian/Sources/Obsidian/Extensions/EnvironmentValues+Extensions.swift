//
//  EnvironmentValues+Extensions.swift
//  Obsidian
//
//  Created by Arthur Porto on 07/11/25.
//

import SwiftUI

public extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}
