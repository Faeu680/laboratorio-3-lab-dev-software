//
//  BenefitModel.swift
//  Domain
//
//  Created by Arthur Porto on 07/11/25.
//

public struct BenefitModel: Hashable {
    public let id: String
    public let name: String
    public let description: String
    public let photo: String?
    public let cost: String
    public let active: Bool
    public let companyId: String
    public let companyName: String?
    
    public init(
        id: String,
        name: String,
        description: String,
        photo: String?,
        cost: String,
        active: Bool,
        companyId: String,
        companyName: String?
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.photo = photo
        self.cost = cost
        self.active = active
        self.companyId = companyId
        self.companyName = companyName
    }
}
