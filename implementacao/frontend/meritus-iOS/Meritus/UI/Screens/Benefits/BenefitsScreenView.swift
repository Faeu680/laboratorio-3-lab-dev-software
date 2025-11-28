//
//  BenefitsScreenView.swift
//  Meritus
//
//  Created by Arthur Porto on 03/11/25.
//

import SwiftUI
import Obsidian
import Domain
import Session
import Navigation

struct BenefitsScreenView: View {
    @Environment(\.navigator) private var navigator: NavigatorProtocol
    
    @StateObject private var viewModel: BenefitsScreenViewModel
    
    init(viewModel: BenefitsScreenViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            ForEach(viewModel.benefits, id: \.self) { benefit in
                benefitCardView(benefit)
            }
        }
        .scrollIndicators(.never)
        .searchable(
            text: .constant(""),
            prompt: "Buscar beneficio"
        )
        .if(viewModel.userRole == .student) { view in
            view
                .navigationTitle("Resgatar")
                .navigationSubtitle("Selecione um beneficio para resgatar")
                .toolbarTitleDisplayMode(.inlineLarge)
                .fullScreenCover(isPresented: $viewModel.showRedeemSheet) {
                    NavigationStack {
                        redeemSheetModalView()
                    }
                }
        }
        .if(viewModel.userRole == .company) { view in
            ZStack(alignment: .bottomTrailing) {
                view
                    .applyMeritusToolbarTitle()
                
                createBenefitButtonView()
            }
        }
        .onViewDidLoad {
            bindActions()
        }
        .onAppear {
            await viewModel.onViewDidLoad()
        }
    }
}

extension BenefitsScreenView {
    private func bindActions() {
        viewModel.redeemBenefitDidSuccess = { benefit in
            navigator.navigate(to: AppRoutes.benefitInfo(benefit: benefit))
        }
    }
}

extension BenefitsScreenView {
    private func benefitCardView(_ benefit: BenefitModel) -> some View {
        BenefitCard(
            title: benefit.name,
            description: benefit.description,
            price: benefit.cost,
            imageURL: benefit.photo
        )
        .if(viewModel.userRole == .student) { view in
            view
                .onTap {
                    await viewModel.showRedeemSheet(for: benefit)
                }
        }
        .padding(.horizontal, .size16)
    }
}

extension BenefitsScreenView {
    private func createBenefitButtonView() -> some View {
        Button {
            navigator.navigate(to: AppRoutes.newBenefit)
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 20, weight: .regular))
                .frame(width: 32, height: 32)
                .clipShape(Circle())
                .contentShape(Circle())
        }
        .buttonStyle(.glass)
        .padding(.bottom, .size8)
        .padding(.trailing, .size24)
    }
}

extension BenefitsScreenView {
    private func redeemSheetModalView() -> some View {
        VStack {
            ScrollView {
                selectedBenefitCardView()
                    .padding(.top, .size16)
                
                VStack {
                    balanceListItem(
                        title: "Saldo Atual",
                        balance: viewModel.balance
                    )
                    
                    balanceListItem(
                        title: "Saldo Final",
                        balance: viewModel.finalBalance
                    )
                }
                .padding(.top, .size16)
            }
            .navigationTitle("Resgate")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.dismissRedeemSheet()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                    }
                }
            }
            .scrollIndicators(.never)
            
            Spacer()
            
            redeemButtonView()
        }
    }
}

extension BenefitsScreenView {
    @ViewBuilder
    private func selectedBenefitCardView() -> some View {
        if let benefit = viewModel.selectedBenefit {
            BenefitCard(
                title: benefit.name,
                description: benefit.description,
                price: benefit.cost,
                imageURL: benefit.photo
            )
            .padding(.horizontal, .size16)
        }
    }
}

extension BenefitsScreenView {
    private func balanceListItem(
        title: String,
        balance: String
    ) -> some View {
        ObsidianListItem(
            title: title,
            trailing: Text("MC \(balance)")
                .obsidianBody()
        )
        .padding(.horizontal, .size16)
    }
}

extension BenefitsScreenView {
    private func redeemButtonView() -> some View {
        ObsidianButton(
            "Resgatar",
            style: .primary,
            isLoading: $viewModel.isLoading,
        ) {
            await viewModel.didTapToRedeemBenefit()
        }
        .padding(.horizontal, .size16)
        .padding(.bottom, .size16)
    }
}
