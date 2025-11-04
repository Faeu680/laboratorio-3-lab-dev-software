//
//  HomeScreenView.swift
//  Meritus
//
//  Created by Arthur Porto on 29/10/25.
//

import SwiftUI
import Obsidian

struct HomeScreenView: View {

    @StateObject private var viewModel: HomeScreenViewModel
    private let isBusiness = false

    init(viewModel: HomeScreenViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        TabView {
            NavigationView {
                if isBusiness {
                    // Empresa Somente
                    BenefitsScreenView(viewModel: .init())
                        .applyHomeToolbar()
                } else {
                    // Aluno e Professor Somente
                    ExtractScreenView(viewModel: .init())
                        .applyHomeToolbar()
                }
            }
            .tabItem {
                Label("Início", systemImage: "house.fill")
            }

            // Professor Somente
            NavigationView {
                TransferScreenView(viewModel: .init())
            }
            .tabItem {
                Label("Transferir", systemImage: "arrow.left.arrow.right.circle.fill")
            }

                
            // Aluno Somente
            NavigationView {
                RedeemScreenView(viewModel: .init())
            }
            .tabItem {
                Label("Resgatar", systemImage: "creditcard.fill")
            }

            // Ajustes / Perfil
            NavigationView {
                Text("Ajustes")
            }
            .tabItem {
                Label("Ajustes", systemImage: "gearshape.fill")
            }
        }
        .navigationBarBackButtonHidden()
    }
}

private extension View {
    func applyHomeToolbar() -> some View {
        self.toolbar {
            ToolbarItem(placement: .subtitle) {
                Text("MERITUS")
                    .meritusTitle()
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // ação do avatar (ex: ir para perfil)
                } label: {
                    AvatarView(size: 32)
                }
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

#Preview {
    ObsidianPreviewContainer {
        HomeScreenView(viewModel: .init())
    }
}
