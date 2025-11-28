//
//  StudentModel.swift
//  Domain
//
//  Created by Arthur Porto on 21/11/25.
//

public struct StudentModel: Sendable {
    public let id: String
    public let name: String
    public let email: String
    
    public init(
        id: String,
        name: String,
        email: String
    ) {
        self.id = id
        self.name = name
        self.email = email
    }
}
