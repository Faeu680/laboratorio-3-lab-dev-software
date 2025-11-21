//
//  GetBalanceUseCaseProtocol.swift
//  Domain
//
//  Created by Arthur Porto on 21/11/25.
//

public protocol GetBalanceUseCaseProtocol: Sendable {
    func execute() async throws(GetBalanceUseCaseError) -> String
}
