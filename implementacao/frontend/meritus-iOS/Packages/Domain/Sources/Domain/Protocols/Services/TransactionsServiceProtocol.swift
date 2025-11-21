//
//  TransactionsServiceProtocol.swift
//  Domain
//
//  Created by Arthur Porto on 21/11/25.
//

public protocol TransactionsServiceProtocol: Sendable {
    func transfer() async throws(ServiceError)
    func getExtract() async throws(ServiceError) -> [TransactionModel]
}
