//
//  SplashScreenView.swift
//  Meritus
//
//  Created by Arthur Porto on 31/10/25.
//

import SwiftUI
import Navigation

struct SplashScreenView: View {
    
    @Environment(\.navigator) private var navigator: NavigatorProtocol
    
    var body: some View {
        Text("Splash Screen")
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    navigator.navigate(to: AppRoutes.login)
                }
            }
    }
}
