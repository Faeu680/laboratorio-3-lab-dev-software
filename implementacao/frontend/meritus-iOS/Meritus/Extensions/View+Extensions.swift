//
//  View+Extensions.swift
//  Meritus
//
//  Created by Arthur Porto on 17/11/25.
//

import SwiftUI
import Obsidian

extension View {
    func applyMeritusToolbarTitle() -> some View {
        self.modifier(MeritusToolbarTitleModifier())
    }
}
