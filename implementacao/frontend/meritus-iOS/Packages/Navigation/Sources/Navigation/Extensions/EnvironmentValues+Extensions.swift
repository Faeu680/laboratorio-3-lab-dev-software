//
//  EnvironmentValues+Extensions.swift
//  Navigation
//
//  Created by Arthur Porto on 29/10/25.
//

import SwiftUI

@MainActor
public extension EnvironmentValues {
    var navigator: NavigatorProtocol {
        get { self[NavigatorKey.self] }
        set { self[NavigatorKey.self] = newValue }
    }
}
