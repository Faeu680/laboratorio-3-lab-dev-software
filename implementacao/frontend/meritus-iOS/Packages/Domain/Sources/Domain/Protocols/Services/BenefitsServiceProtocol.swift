//
//  BenefitsServiceProtocol.swift
//  Domain
//
//  Created by Arthur Porto on 07/11/25.
//

public protocol BenefitsServiceProtocol: Sendable {
    func createBenefit(
        name: String,
        description: String,
        photo: String,
        cost: String
    ) async throws(ServiceError)
    
    func getBenefits() async throws(ServiceError) -> [BenefitModel]
    
    func getMyBenefits() async throws(ServiceError) -> [RedeemBenefitModel]
}
