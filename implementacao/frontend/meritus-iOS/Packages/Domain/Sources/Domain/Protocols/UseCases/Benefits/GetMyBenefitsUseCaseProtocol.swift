//
//  GetMyBenefitsUseCaseProtocol.swift
//  Domain
//
//  Created by Arthur Porto on 28/11/25.
//

public protocol GetMyBenefitsUseCaseProtocol: Sendable {
    func execute() async throws(GetMyBenefitsUseCaseError) -> [RedeemBenefitModel]
}
