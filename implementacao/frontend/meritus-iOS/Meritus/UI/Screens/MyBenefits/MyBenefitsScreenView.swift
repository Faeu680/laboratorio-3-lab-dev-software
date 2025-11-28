//
//  MyBenefitsScreenView.swift
//  Meritus
//
//  Created by Arthur Porto on 28/11/25.
//

import SwiftUI
import Obsidian
import Domain
import Navigation

struct MyBenefitsScreenView: View {
    
    @Environment(\.navigator) private var navigator: NavigatorProtocol
    
    @StateObject private var viewModel: MyBenefitsScreenViewModel
    
    init(viewModel: MyBenefitsScreenViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            ForEach(viewModel.myBenefits, id: \.self) { benefit in
                benefitCardView(benefit)
            }
        }
        .scrollIndicators(.never)
        .navigationTitle("Meus Benefícios")
        .navigationSubtitle("Selecione o benefício que deseja utilizar")
        .toolbarTitleDisplayMode(.inlineLarge)
        .onAppear {
            await viewModel.onViewDidLoad()
        }
    }
}

extension MyBenefitsScreenView {
    private func benefitCardView(_ benefit: RedeemBenefitModel) -> some View {
        BenefitCard(
            title: benefit.name,
            description: benefit.description,
            price: benefit.cost,
            imageURL: benefit.photo
        ) {
            await navigator.navigate(to: AppRoutes.benefitInfo(benefit: benefit))
        }
        .padding(.horizontal, .size16)
    }
}
