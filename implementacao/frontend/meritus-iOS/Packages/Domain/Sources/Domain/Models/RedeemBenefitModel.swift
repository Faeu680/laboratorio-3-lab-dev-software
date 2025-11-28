//
//  RedeemBenefitModel.swift
//  Domain
//
//  Created by Arthur Porto on 28/11/25.
//

public struct RedeemBenefitModel: Hashable, Sendable {
    public let id: String
    public let name: String
    public let description: String
    public let photo: String
    public let cost: String
    public let active: Bool
    public let companyId: String
    public let voucherCode: String
    
    public init(
        id: String,
        name: String,
        description: String,
        photo: String,
        cost: String,
        active: Bool,
        companyId: String,
        voucherCode: String
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.photo = photo
        self.cost = cost
        self.active = active
        self.companyId = companyId
        self.voucherCode = voucherCode
    }
}
