//
//  GetMyBenefitsResponse.swift
//  Services
//
//  Created by Arthur Porto on 28/11/25.
//

import Domain

struct GetMyBenefitsResponse: Decodable {
    let voucherCode: String
    let benefit: Benefit
    
    struct Benefit: Decodable {
        let id: String
        let name: String
        let description: String
        let photo: String
        let cost: String
        let active: Bool
        let companyId: String
    }
    
    public func toDomain() -> RedeemBenefitModel {
        RedeemBenefitModel(
            id: benefit.id,
            name: benefit.name,
            description: benefit.description,
            photo: benefit.photo,
            cost: benefit.cost,
            active: benefit.active,
            companyId: benefit.companyId,
            voucherCode: voucherCode
        )
    }
}
