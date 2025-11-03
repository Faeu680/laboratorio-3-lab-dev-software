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
        do {
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
            let response: NetworkResponse<SigninResponse> = try await network.request(request)
            let accessToken = response.data.accessToken

            return accessToken
        } catch {
            throw ServiceError(from: error)
        }
    }
}
