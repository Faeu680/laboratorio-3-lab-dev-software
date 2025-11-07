//
//  CreateBenefitModel.swift
//  Domain
//
//  Created by Arthur Porto on 07/11/25.
//

public struct CreateBenefitModel {
    let name: String
    let description: String
    let photo: String
    let cost: Double
    
    public init(
        name: String,
        description: String,
        photo: String,
        cost: Double
    ) {
        self.name = name
        self.description = description
        self.photo = photo
        self.cost = cost
    }
}
