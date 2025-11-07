//
//  CompaniesServiceProtocol.swift
//  Domain
//
//  Created by Arthur Porto on 07/11/25.
//

public protocol CompaniesServiceProtocol: Sendable {
    func signUp(
        name: String,
        email: String,
        password: String,
        cnpj: String,
        address: String,
        description: String,
    ) async throws(ServiceError) -> String
}
