//
//  GetTransactionsUseCaseProtocol.swift
//  Domain
//
//  Created by Arthur Porto on 21/11/25.
//

public protocol GetTransactionsUseCaseProtocol: Sendable {
    func execute() async throws(GetTransactionsUseCaseError) -> [TransactionModel]
}
