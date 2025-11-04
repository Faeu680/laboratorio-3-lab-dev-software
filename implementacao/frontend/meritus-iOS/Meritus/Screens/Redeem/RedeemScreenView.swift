//
//  RedeemScreenView.swift
//  Meritus
//
//  Created by Arthur Porto on 03/11/25.
//

import SwiftUI
import Obsidian

struct RedeemScreenView: View {
    @StateObject private var viewModel: RedeemScreenViewModel
    
    init(viewModel: RedeemScreenViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            ForEach(0..<10, id: \.self) { index in
                benefitCardView()
            }
        }
        .scrollIndicators(.never)
        .navigationTitle("Resgatar")
        .navigationSubtitle("Selecione um beneficio para resgatar")
        .toolbarTitleDisplayMode(.inlineLarge)
    }
}

extension RedeemScreenView {
    private func benefitCardView() -> some View {
        BenefitCard(
            title: "Spa Premium Experience",
            description: "Dia completo de relaxamento em spa 5 estrelas com massagem e tratamento facial. Inclui acesso à sauna e piscina aquecida.",
            price: 850,
            image: Image("spa_header")
        )
        .padding(.horizontal, .size16)
    }
}
