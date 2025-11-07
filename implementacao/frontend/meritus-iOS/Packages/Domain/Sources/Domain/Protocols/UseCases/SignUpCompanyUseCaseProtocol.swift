//
//  SignUpCompanyUseCaseProtocol.swift
//  Domain
//
//  Created by Arthur Porto on 07/11/25.
//

public protocol SignUpCompanyUseCaseProtocol: Sendable {
    func execute(company: RegisterCompanyModel) async throws(SignUpCompanyUseCaseError)
}

