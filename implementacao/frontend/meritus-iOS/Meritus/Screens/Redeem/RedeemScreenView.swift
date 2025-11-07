//
//  RedeemScreenView.swift
//  Meritus
//
//  Created by Arthur Porto on 03/11/25.
//

import SwiftUI
import Obsidian
import Domain

struct RedeemScreenView: View {
    @StateObject private var viewModel: RedeemScreenViewModel
    
    init(viewModel: RedeemScreenViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            ForEach(viewModel.benefits, id: \.self) { benefit in
                benefitCardView(
                    title: benefit.name,
                    description: benefit.description,
                    imageUrl: benefit.photo ?? ""
                )
            }
        }
        .scrollIndicators(.never)
        .navigationTitle("Resgatar")
        .navigationSubtitle("Selecione um beneficio para resgatar")
        .toolbarTitleDisplayMode(.inlineLarge)
        .onViewDidLoad {
            Task(priority: .userInitiated) {
                await viewModel.onViewDidLoad()
            }
        }
    }
}

extension RedeemScreenView {
    private func benefitCardView(
        title: String,
        description: String,
        imageUrl: String
    ) -> some View {
        BenefitCard(
            title: title,
            description: description,
            price: 850,
            image: Image(imageUrl)
        )
        .padding(.horizontal, .size16)
    }
}
