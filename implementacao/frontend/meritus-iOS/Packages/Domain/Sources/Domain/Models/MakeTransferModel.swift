//
//  MakeTransferModel.swift
//  Domain
//
//  Created by Arthur Porto on 21/11/25.
//

public struct MakeTransferModel {
    let studentId: String
    let amount: String
    let message: String
    
    public init(
        studentId: String,
        amount: String,
        message: String
    ) {
        self.studentId = studentId
        self.amount = amount
        self.message = message
    }
}
