//
//  TransactionModel.swift
//  Domain
//
//  Created by Arthur Porto on 21/11/25.
//

import Foundation

public struct TransactionModel {
    public let id: String
    public let type: TransactionType
    public let amount: Decimal
    public let createdAt: Date
    
    public init(
        id: String,
        type: TransactionType,
        amount: Decimal,
        createdAt: Date
    ) {
        self.id = id
        self.type = type
        self.amount = amount
        self.createdAt = createdAt
    }
}
