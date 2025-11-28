//
//  RedeemBenefitUseCaseProtocol.swift
//  Domain
//
//  Created by Arthur Porto on 28/11/25.
//

public protocol RedeemBenefitUseCaseProtocol: Sendable {
    func execute(benefitId: String) async throws(RedeemBenefitUseCaseError) -> RedeemBenefitModel
}
