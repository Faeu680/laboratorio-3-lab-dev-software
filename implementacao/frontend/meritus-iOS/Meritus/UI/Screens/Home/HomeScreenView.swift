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
                Tab("Início", systemImage: "house.fill") {
                    NavigationView {
                        navigator.view(for: AppRoutes.benefits)
                    }
                }
                
                Tab("Início", systemImage: "house.fill") {
                    NavigationView {
                        navigator.view(for: AppRoutes.newBenefit)
                    }
                }
            } else {
                Tab("Início", systemImage: "house.fill") {
                    NavigationView {
                        navigator.view(for: AppRoutes.extract)
                    }
                }
            }
            
            if viewModel.isTeacher {
                Tab("Transferir", systemImage: "arrow.left.arrow.right.circle.fill", role: .search) {
                    NavigationView {
                        navigator.view(for: AppRoutes.transfer)
                    }
                }
            }
            
            if viewModel.isStudent {
                Tab("Resgatar", systemImage: "creditcard.fill") {
                    NavigationView {
                        navigator.view(for: AppRoutes.redeem)
                    }
                }
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .navigationBarBackButtonHidden()
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
