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
    let amount: String
    let createdAt: String
    
    func toDomain() -> TransactionModel {
        TransactionModel(
            id: id,
            type: type,
            origin: origin,
            amount: amount,
            createdAt: createdAt
        )
    }
}
