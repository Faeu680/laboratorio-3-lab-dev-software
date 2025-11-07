//
//  SafeAreaInsetsKey.swift
//  Obsidian
//
//  Created by Arthur Porto on 07/11/25.
//

import SwiftUI

struct SafeAreaInsetsKey: @preconcurrency EnvironmentKey {
    @MainActor
    static let defaultValue: EdgeInsets = {
        let window = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
        let insets = window?.safeAreaInsets ?? .zero
        return EdgeInsets(
            top: insets.top,
            leading: insets.left,
            bottom: insets.bottom,
            trailing: insets.right
        )
    }()
}
