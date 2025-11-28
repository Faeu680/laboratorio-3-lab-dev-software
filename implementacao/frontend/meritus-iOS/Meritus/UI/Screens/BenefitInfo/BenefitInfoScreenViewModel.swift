//
//  BenefitInfoScreenViewModel.swift
//  Meritus
//
//  Created by Arthur Porto on 28/11/25.
//

import Combine
import Domain

final class BenefitInfoScreenViewModel: ObservableObject {
    
    let benefit: RedeemBenefitModel
    
    init(benefit: RedeemBenefitModel) {
        self.benefit = benefit
    }
}
