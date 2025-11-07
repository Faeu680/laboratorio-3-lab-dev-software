//
//  CreateBenefitUseCaseProtocol.swift
//  Domain
//
//  Created by Arthur Porto on 07/11/25.
//

public protocol CreateBenefitUseCaseProtocol: Sendable {
    func execute(_ benefit: CreateBenefitModel) async throws(CreateBenefitUseCaseError)
}
