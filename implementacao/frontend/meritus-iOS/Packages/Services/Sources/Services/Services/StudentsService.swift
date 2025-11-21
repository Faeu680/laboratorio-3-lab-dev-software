//
//  StudentsService.swift
//  Services
//
//  Created by Arthur Porto on 02/11/25.
//

import Domain
import Networking

final class StudentsService: StudentsServiceProtocol {
    private let network: NetworkClientProtocol

    init(network: NetworkClientProtocol) {
        self.network = network
    }
    
    func signUp(
        name: String,
        email: String,
        password: String,
        cpf: String,
        rg: String,
        address: String,
        course: String,
        institutionId: String
    ) async throws(ServiceError) -> String {
        let request = StudentsRequest.signUp(
            name: name,
            email: email,
            password: password,
            cpf: cpf,
            rg: rg,
            address: address,
            course: course,
            institutionId: institutionId
        )
        
        do {
            let response: NetworkResponse<SigninResponse> = try await network.request(request)
            let accessToken = response.data.accessToken

            return accessToken
        } catch {
            throw ServiceError(from: error)
        }
    }
    
    func getStudentsOfInstitution() async throws(ServiceError) -> [StudentModel] {
        let request = StudentsRequest.getStudentsOfInstitution
        
        do {
            let response: NetworkResponse<[GetStudentResponse]> = try await network.request(request)
            let mapped = response.data.toDomain()
            return mapped
        } catch {
            throw ServiceError(from: error)
        }
    }
}

fileprivate extension Array where Element == GetStudentResponse {
    func toDomain() -> [StudentModel] {
        map { $0.toDomain() }
    }
}
