//
//  BenefitInfoScreenView.swift
//  Meritus
//
//  Created by Arthur Porto on 28/11/25.
//

import SwiftUI
import Obsidian
import Domain

struct BenefitInfoScreenView: View {
    
    @StateObject private var viewModel: BenefitInfoScreenViewModel
    
    init(viewModel: BenefitInfoScreenViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            QRCodeView(from: viewModel.benefit.voucherCode)
                .frame(height: 300)
                .padding(.top, .size16)
            
            VStack(spacing: .size16) {
                Text(viewModel.benefit.name)
                    .obsidianBody()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                
                Text(viewModel.benefit.description)
                    .obsidianLabel()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
            }
            .padding([.top, .horizontal], .size16)
            
            Spacer()
        }
        .navigationTitle("Benefício")
        .toolbarTitleDisplayMode(.inlineLarge)
    }
}
