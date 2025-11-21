//
//  TransactionsService.swift
//  Services
//
//  Created by Arthur Porto on 21/11/25.
//

import Domain
import Networking

final class TransactionsService: TransactionsServiceProtocol {
    private let network: NetworkClientProtocol

    init(network: NetworkClientProtocol) {
        self.network = network
    }
    
    func transfer() async throws(ServiceError) {
        
    }
    
    func getExtract() async throws(ServiceError) -> [TransactionModel] {
        let request = TransactionsRequest.getExtract
        
        do {
            let response: NetworkResponse<[GetExtractResponse]> = try await network.request(request)
            let mapped = response.data.toDomain()
            return mapped
        } catch {
            throw ServiceError(from: error)
        }
    }
}

fileprivate extension Array where Element == GetExtractResponse {
    func toDomain() -> [TransactionModel] {
        map { $0.toDomain() }
    }
}

