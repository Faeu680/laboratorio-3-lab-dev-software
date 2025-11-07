//
//  GetBenefitsUseCase.swift
//  Domain
//
//  Created by Arthur Porto on 07/11/25.
//

final class GetBenefitsUseCase: GetBenefitsUseCaseProtocol {
    
    private let service: BenefitsServiceProtocol

    init(service: BenefitsServiceProtocol) {
        self.service = service
    }
    
    func execute() async throws(GetBenefitsUseCaseError) -> [BenefitModel] {
        do {
            let benefits = try await service.getBenefits()
            return benefits
        } catch {
            throw .todo
        }
    }
}
