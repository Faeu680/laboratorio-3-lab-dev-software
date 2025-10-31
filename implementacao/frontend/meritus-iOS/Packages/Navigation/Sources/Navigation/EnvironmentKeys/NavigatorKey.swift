//
//  NavigatorKey.swift
//  Navigation
//
//  Created by Arthur Porto on 29/10/25.
//

import SwiftUI

@MainActor
struct NavigatorKey: @MainActor EnvironmentKey {
    static let defaultValue: NavigatorProtocol = Navigator.shared
}
