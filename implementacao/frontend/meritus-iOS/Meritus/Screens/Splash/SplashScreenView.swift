//
//  SplashScreenView.swift
//  Meritus
//
//  Created by Arthur Porto on 31/10/25.
//

import SwiftUI
import Navigation
import Obsidian

struct SplashScreenView: View {
    
    @Environment(\.navigator) private var navigator: NavigatorProtocol
    
    @StateObject private var viewModel: SplashScreenViewModel
    
    init(viewModel: SplashScreenViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Text("Splash Screen")
            .onViewDidLoad {
                bindActions()
                
                Task(priority: .userInitiated) {
                    await viewModel.onViewDidLoad()
                }
            }
    }
}

extension SplashScreenView {
    private func bindActions() {
        viewModel.onLoginSuccess = {
            navigator.navigate(to: AppRoutes.home)
        }
        
        viewModel.onLoginFailure = {
            navigator.navigate(to: AppRoutes.login)
        }
    }
}
