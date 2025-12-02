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
    public let origin: TransactionOrigin
    public let message: String
    public let amount: String
    public let createdAt: String
    
    public init(
        id: String,
        type: TransactionType,
        origin: TransactionOrigin,
        message: String,
        amount: String,
        createdAt: String
    ) {
        self.id = id
        self.type = type
        self.origin = origin
        self.message = message
        self.amount = amount
        self.createdAt = createdAt
    }
}
