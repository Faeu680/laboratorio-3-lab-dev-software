//
//  TransactionsServiceProtocol.swift
//  Domain
//
//  Created by Arthur Porto on 21/11/25.
//

public protocol TransactionsServiceProtocol: Sendable {
    func transfer(
        studentId: String,
        amount: String,
        message: String
    ) async throws(ServiceError)
    
    func getExtract() async throws(ServiceError) -> [TransactionModel]
    
    func getBalance() async throws(ServiceError) -> String
    
    func redeemBenefit(benefitId: String) async throws(ServiceError) -> RedeemBenefitModel
}
