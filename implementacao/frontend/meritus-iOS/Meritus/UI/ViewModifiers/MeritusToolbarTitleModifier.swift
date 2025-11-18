//
//  MeritusToolbarTitleModifier.swift
//  Meritus
//
//  Created by Arthur Porto on 18/11/25.
//

import SwiftUI
import Obsidian
import Navigation

struct MeritusToolbarTitleModifier: ViewModifier {
    @Environment(\.navigator) private var navigator: NavigatorProtocol
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .subtitle) {
                    Text("MERITUS")
                        .meritusTitle()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        navigator.navigate(to: AppRoutes.settings)
                    } label: {
                        Image(systemName: "person.crop.circle.fill")
                    }
                }
            }
    }
}
