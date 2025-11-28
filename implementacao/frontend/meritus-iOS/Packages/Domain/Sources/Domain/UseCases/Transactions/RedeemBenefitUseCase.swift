//
//  RedeemBenefitUseCase.swift
//  Domain
//
//  Created by Arthur Porto on 28/11/25.
//

final class RedeemBenefitUseCase: RedeemBenefitUseCaseProtocol {
    private let service: TransactionsServiceProtocol
    
    init(service: TransactionsServiceProtocol) {
        self.service = service
    }
    
    func execute(benefitId: String) async throws(RedeemBenefitUseCaseError) -> RedeemBenefitModel {
        do {
            let redeemBenefit = try await service.redeemBenefit(benefitId: benefitId)
            return redeemBenefit
        } catch {
            throw .todo
        }
    }
}
