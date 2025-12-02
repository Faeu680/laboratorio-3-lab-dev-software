//
//  BenefitsScreenViewType.swift
//  Meritus
//
//  Created by Arthur Porto on 02/12/25.
//

enum BenefitsScreenViewType: Hashable, CaseIterable {
    case redeem
    case myBenefits
    
    var description: String {
        switch self {
        case .redeem: return "Resgatar"
        case .myBenefits: return "Meus Benefícios"
        }
    }
}
