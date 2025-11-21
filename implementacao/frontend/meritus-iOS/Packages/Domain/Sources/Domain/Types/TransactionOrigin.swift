//
//  TransactionOrigin.swift
//  Domain
//
//  Created by Arthur Porto on 21/11/25.
//

public enum TransactionOrigin: String, Decodable, Sendable {
    case income = "INCOME"
    case outcome = "OUTCOME"
}
