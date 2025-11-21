//
//  TransactionType.swift
//  Domain
//
//  Created by Arthur Porto on 21/11/25.
//

public enum TransactionType: String, Decodable, Sendable {
    case transfer = "TRANSFER"
    case redemption = "REDEMPTION"
    case credit = "CREDIT"
}
