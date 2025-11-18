//
//  ColorSchemeManagerProtocol.swift
//  Meritus
//
//  Created by Arthur Porto on 18/11/25.
//

import SwiftUI
import Combine

@MainActor
protocol ColorSchemeManagerProtocol: ObservableObject {
    func setColorScheme(_ colorScheme: ColorScheme?)
}
