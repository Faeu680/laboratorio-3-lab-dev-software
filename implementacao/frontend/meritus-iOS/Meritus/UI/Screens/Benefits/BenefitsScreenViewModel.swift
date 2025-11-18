//
//  BenefitsScreenViewModel.swift
//  Meritus
//
//  Created by Arthur Porto on 03/11/25.
//

import SwiftUI
import Combine
import Domain

@MainActor
final class BenefitsScreenViewModel: ObservableObject {
    
    private let createBenefitUseCase: CreateBenefitUseCaseProtocol
    
    init(createBenefitUseCase: CreateBenefitUseCaseProtocol) {
        self.createBenefitUseCase = createBenefitUseCase
    }
    
    func didTapCreateBenefit() async {
//        let model = CreateBenefitModel(
//            name: name,
//            description: description,
//            photo: "",
//            cost: 10.0
//        )
        
//        try? await createBenefitUseCase.execute(model)
    }
}
