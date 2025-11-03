//
//  AuthService.swift
//  Services
//
//  Created by Arthur Porto on 17/10/25.
//

import Domain
import Networking

final class AuthService: AuthServiceProtocol {
    private let network: NetworkClientProtocol

    init(network: NetworkClientProtocol) {
        self.network = network
    }

    func signIn(email: String, password: String) async throws(ServiceError) -> String {
        do {
            let request = SigninRequest(email: email, password: password)
            let response: NetworkResponse<SigninResponse> = try await network.request(request)
            let accessToken = response.data.accessToken

            return accessToken
        } catch {
            throw ServiceError(from: error)
        }
    }
}
