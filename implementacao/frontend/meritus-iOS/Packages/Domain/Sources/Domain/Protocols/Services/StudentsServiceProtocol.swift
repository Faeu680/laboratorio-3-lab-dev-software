//
//  StudentsServiceProtocol.swift
//  Domain
//
//  Created by Arthur Porto on 02/11/25.
//

public protocol StudentsServiceProtocol: Sendable {
    func signUp(
        name: String,
        email: String,
        password: String,
        cpf: String,
        rg: String,
        address: String,
        course: String,
        institutionId: String
    ) async throws(ServiceError) -> String
    
    func getStudentsOfInstitution() async throws(ServiceError) -> [StudentModel]
}
