//
//  TransactionsRequest.swift
//  Services
//
//  Created by Arthur Porto on 21/11/25.
//

import Networking

enum TransactionsRequest: APIRequest {
    case transfer(
        studentId: String,
        amount: String,
        message: String
    )
    
    case getExtract
    
    case getBalance
    
    case redeemBenefit(benefitId: String)
    
    static let basePath = "/transactions"
    
    var scope: APIScope {
        return .authenticated
    }
    
    var path: String {
        switch self {
        case .transfer:
            return Self.basePath + "/transfer"
        case .getExtract:
            return Self.basePath + "/extract"
        case .getBalance:
            return Self.basePath + "/balance"
        case .redeemBenefit:
            return Self.basePath + "/redeem"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .transfer, .redeemBenefit:
            return .post
        case .getExtract, .getBalance:
            return .get
        }
    }
    
    var body: BodyType {
        switch self {
        case let .transfer(studentId, amount, message):
            return .json(
                TransferBody(
                    studentId: studentId,
                    amount: amount,
                    message: message
                )
            )
        case let .redeemBenefit(benefitId):
            return .json(
                RedeemBenefitBody(benefitId: benefitId)
            )
        case .getExtract, .getBalance:
            return .none
        }
    }
    
    private struct TransferBody: Encodable {
        let studentId: String
        let amount: String
        let message: String
    }
    
    private struct RedeemBenefitBody: Encodable {
        let benefitId: String
    }
}
