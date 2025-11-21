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
    
    func transfer(
        studentId: String,
        amount: String,
        message: String
    ) async throws(ServiceError) {
        let request = TransactionsRequest.transfer(
            studentId: studentId,
            amount: amount,
            message: message
        )
        
        do {
            try await network.request(request)
        } catch {
            throw ServiceError(from: error)
        }
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
    
    func getBalance() async throws(ServiceError) -> String {
        let request = TransactionsRequest.getBalance
        
        do {
            let response: NetworkResponse<GetBalanceResponse> = try await network.request(request)
            let balance = response.data.balance
            return balance
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

