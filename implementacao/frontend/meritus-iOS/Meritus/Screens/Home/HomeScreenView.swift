//
//  HomeScreenView.swift
//  Meritus
//
//  Created by Arthur Porto on 29/10/25.
//

import SwiftUI
import Obsidian
import Navigation

struct HomeScreenView: View {
    
    @Environment(\.navigator) private var navigator: NavigatorProtocol
    
    @StateObject private var viewModel: HomeScreenViewModel
    
    init(viewModel: HomeScreenViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        TabView {
            if viewModel.isCompany {
                NavigationView {
                    navigator.view(for: AppRoutes.benefits)
                }
                .tabItem {
                    Label("Início", systemImage: "house.fill")
                }
            }
            
            if !viewModel.isCompany {
                NavigationView {
                    ExtractScreenView(viewModel: .init())
                }
                .tabItem {
                    Label("Início", systemImage: "house.fill")
                }
            }
            
            if viewModel.isTeacher {
                NavigationView {
                    TransferScreenView(viewModel: .init())
                }
                .tabItem {
                    Label("Transferir", systemImage: "arrow.left.arrow.right.circle.fill")
                }
            }
            
            if viewModel.isStudent {
                NavigationView {
                    navigator.view(for: AppRoutes.redeem)
                }
                .tabItem {
                    Label("Resgatar", systemImage: "creditcard.fill")
                }
            }
            
            NavigationView {
                settingsView()
            }
            .tabItem {
                Label("Ajustes", systemImage: "gearshape.fill")
            }
        }
        .navigationBarBackButtonHidden()
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}

extension HomeScreenView {
    private func settingsView() -> some View {
        ObsidianButton(
            "Logout",
            style: .primary,
        ) {
            Task {
                await viewModel.didTapLogout()
            }
        }
    }
}

private struct AvatarView: View {
    var size: CGFloat = 32
    var body: some View {
        ZStack {
            Circle().fill(Color.gray.opacity(0.2))
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFit()
                .padding(size * 0.12)
        }
        .frame(width: size, height: size)
    }
}
