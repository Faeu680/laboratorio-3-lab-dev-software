//
//  CreateBenefitUseCase.swift
//  Domain
//
//  Created by Arthur Porto on 07/11/25.
//

final class CreateBenefitUseCase: CreateBenefitUseCaseProtocol {
    
    private let service: BenefitsServiceProtocol

    init(service: BenefitsServiceProtocol) {
        self.service = service
    }
    
    func execute(_ benefit: CreateBenefitModel) async throws(CreateBenefitUseCaseError) {
        do {
            try await service.createBenefit(
                name: benefit.name,
                description: benefit.description,
                photo: benefit.photo,
                cost: benefit.cost
            )
        } catch {
            throw mapError(error)
        }
    }
    
    // MARK: - Private Methods
    
    private func mapError(_ error: Error) -> CreateBenefitUseCaseError {
        guard let serviceError = error as? ServiceError else {
            return .unknown
        }
        
        switch serviceError {
        case .unauthorized:
            return .unauthorized
        case .notFound:
            return .companyNotFound
        case let .serverError(statusCode, _):
            guard statusCode == 403 else {
                return .unknown
            }
            return .acessDeniedOnlyBusiness
        default:
            return .unknown
        }
    }
}
