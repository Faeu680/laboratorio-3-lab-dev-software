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
    let amount: Decimal
    let createdAt: Date
    
    func toDomain() -> TransactionModel {
        TransactionModel(
            id: id,
            type: type,
            amount: amount,
            createdAt: createdAt
        )
    }
}
