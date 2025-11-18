//
//  BenefitsScreenView.swift
//  Meritus
//
//  Created by Arthur Porto on 03/11/25.
//

import SwiftUI
import PhotosUI
import Obsidian
import Navigation

struct BenefitsScreenView: View {
    
    @Environment(\.navigator) private var navigator: NavigatorProtocol
    
    @StateObject private var viewModel: BenefitsScreenViewModel

    init(viewModel: BenefitsScreenViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            ForEach(0..<10, id: \.self) { index in
                benefitCardView()
            }
        }
        .scrollIndicators(.never)
        .applyMeritusToolbarTitle()
    }
}

extension BenefitsScreenView {
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
