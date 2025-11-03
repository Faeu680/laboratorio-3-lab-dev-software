//
//  SignUpStudentUseCase.swift
//  Domain
//
//  Created by Arthur Porto on 02/11/25.
//

import Session

final class SignUpStudentUseCase: SignUpStudentUseCaseProtocol {
    private let service: StudentsServiceProtocol
    private let session: SessionProtocol
    
    init(
        service: StudentsServiceProtocol,
        session: SessionProtocol
    ) {
        self.service = service
        self.session = session
    }
    
    func execute(student: RegisterStudentModel) async throws(SignUpStudentUseCaseError) {
        do {
            let token = try await service.signUp(
                name: student.name,
                email: student.email,
                password: student.password,
                cpf: student.cpf,
                rg: student.rg,
                address: student.address,
                course: student.course,
                institutionId: student.institutionId
            )
            try await session.refresh(token: token)
        } catch {
            throw mapError(error)
        }
    }
    
    // MARK: - Private Methods
    
    private func mapError(_ error: Error) -> SignUpStudentUseCaseError {
        if let serviceError = error as? ServiceError, case .unauthorized = serviceError {
            return .invalidData
        }
        
        if let error = error as? SessionError {
            if error == .keychainError {
                return .keychainError
            }
            
            return .initSessionError
        }
        
        return .unknown
    }
}
