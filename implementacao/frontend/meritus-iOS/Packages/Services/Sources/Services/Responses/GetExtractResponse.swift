//
//  GetExtractResponse.swift
//  Services
//
//  Created by Arthur Porto on 21/11/25.
//

import Foundation
import Domain

struct GetExtractResponse: Decodable {
    let id: String
    let type: TransactionType
    let origin: TransactionOrigin
    let message: String
    let amount: String
    let createdAt: String
    
    func toDomain() -> TransactionModel {
        TransactionModel(
            id: id,
            type: type,
            origin: origin,
            message: message,
            amount: amount,
            createdAt: createdAt
        )
    }
}
