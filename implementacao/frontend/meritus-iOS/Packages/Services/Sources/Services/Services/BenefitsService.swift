//
//  BenefitsService.swift
//  Services
//
//  Created by Arthur Porto on 07/11/25.
//

import Domain
import Networking

final class BenefitsService: BenefitsServiceProtocol {
    
    private let network: NetworkClientProtocol

    init(network: NetworkClientProtocol) {
        self.network = network
    }
    
    func createBenefit(
        name: String,
        description: String,
        photo: String,
        cost: Double
    ) async throws(ServiceError) {
        do {
            let request = BenefitsRequest.createBenefit(
                name: name,
                description: description,
                photo: photo,
                cost: cost
            )
            try await network.request(request)
        } catch {
            throw ServiceError(from: error)
        }
    }
    
    func getBenefits() async throws(ServiceError) -> [BenefitModel] {
        do {
            let request = BenefitsRequest.getBenefits
            let response: NetworkResponse<[GetBenefitsResponse]> = try await network.request(request)
            let mapped = response.data.toDomain()
            return mapped
        } catch {
            throw ServiceError(from: error)
        }
    }
}

fileprivate extension Array where Element == GetBenefitsResponse {
    func toDomain() -> [BenefitModel] {
        map { $0.toDomain() }
    }
}
