//
//  SignUpCompanyUseCase.swift
//  Domain
//
//  Created by Arthur Porto on 07/11/25.
//

import Session

final class SignUpCompanyUseCase: SignUpCompanyUseCaseProtocol {
    
    private let service: CompaniesServiceProtocol
    private let session: SessionProtocol
    
    init(
        service: CompaniesServiceProtocol,
        session: SessionProtocol
    ) {
        self.service = service
        self.session = session
    }
    
    func execute(company: RegisterCompanyModel) async throws(SignUpCompanyUseCaseError) {
        do {
            let token = try await service.signUp(
                name: company.name,
                email: company.email,
                password: company.password,
                cnpj: company.cnpj,
                address: company.address,
                description: company.description
            )
            try await session.refresh(token: token)
        } catch {
            throw SignUpCompanyUseCaseError.todo
        }
    }
}
