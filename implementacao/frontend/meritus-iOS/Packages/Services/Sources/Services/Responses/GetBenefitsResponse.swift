//
//  GetBenefitsResponse.swift
//  Services
//
//  Created by Arthur Porto on 07/11/25.
//

import Domain

struct GetBenefitsResponse: Decodable {
    let id: String
    let name: String
    let description: String
    let photo: String
    let cost: String
    let active: Bool
    let companyId: String
    let companyName: String?
    
    func toDomain() -> BenefitModel {
        BenefitModel(
            id: id,
            name: name,
            description: description,
            photo: photo,
            cost: cost,
            active: active,
            companyId: companyId,
            companyName: companyName
        )
    }
}
