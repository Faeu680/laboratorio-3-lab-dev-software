//
//  View+Extensions.swift
//  Meritus
//
//  Created by Arthur Porto on 07/11/25.
//

import SwiftUI
import Obsidian

extension View {
    func applyMeritusToolbarTitle() -> some View {
        self.toolbar {
            ToolbarItem(placement: .subtitle) {
                Text("MERITUS")
                    .meritusTitle()
            }
        }
    }
}
