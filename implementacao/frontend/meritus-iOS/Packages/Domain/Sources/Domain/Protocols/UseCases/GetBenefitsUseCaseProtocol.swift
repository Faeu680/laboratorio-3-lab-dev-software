//
//  GetBenefitsUseCaseProtocol.swift
//  Domain
//
//  Created by Arthur Porto on 07/11/25.
//

public protocol GetBenefitsUseCaseProtocol: Sendable {
    func execute() async throws(GetBenefitsUseCaseError) -> [BenefitModel]
}
