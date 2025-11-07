//
//  CompaniesService.swift
//  Services
//
//  Created by Arthur Porto on 07/11/25.
//

import Domain
import Networking

final class CompaniesService: CompaniesServiceProtocol {
    
    private let network: NetworkClientProtocol

    init(network: NetworkClientProtocol) {
        self.network = network
    }
    
    func signUp(
        name: String,
        email: String,
        password: String,
        cnpj: String,
        address: String,
        description: String,
    ) async throws(ServiceError) -> String {
        do {
            let request = CompaniesRequest.signUp(
                name: name,
                email: email,
                password: password,
                cnpj: cnpj,
                address: address,
                description: description
            )
            let response: NetworkResponse<SigninResponse> = try await network.request(request)
            let accessToken = response.data.accessToken
            
            return accessToken
        } catch {
            throw ServiceError(from: error)
        }
    }
}
