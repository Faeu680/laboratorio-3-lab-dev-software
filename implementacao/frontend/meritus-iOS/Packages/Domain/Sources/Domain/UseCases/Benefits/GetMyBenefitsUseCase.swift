//
//  GetMyBenefitsUseCase.swift
//  Domain
//
//  Created by Arthur Porto on 28/11/25.
//

final class GetMyBenefitsUseCase: GetMyBenefitsUseCaseProtocol {
    private let service: BenefitsServiceProtocol

    init(service: BenefitsServiceProtocol) {
        self.service = service
    }
    
    func execute() async throws(GetMyBenefitsUseCaseError) -> [RedeemBenefitModel] {
        do {
            let benefits = try await service.getMyBenefits()
            return benefits
        } catch {
            throw .todo
        }
    }
}
