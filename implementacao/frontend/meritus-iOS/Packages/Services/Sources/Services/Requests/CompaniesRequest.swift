//
//  CompaniesRequest.swift
//  Services
//
//  Created by Arthur Porto on 07/11/25.
//

import Networking

enum CompaniesRequest: APIRequest {
    case signUp(
        name: String,
        email: String,
        password: String,
        cnpj: String,
        address: String,
        description: String,
    )
    
    var scope: APIScope {
        switch self {
        case .signUp:
            return .unauthenticated
        }
    }
    
    var path: String {
        "/companies"
    }
    
    var method: HTTPMethod {
        switch self {
        case .signUp:
            return .post
        }
    }
    
    var body: (any Encodable)? {
        switch self {
        case let .signUp(name, email, password, cnpj, address, description):
            return SignUpBody(
                name: name,
                email: email,
                password: password,
                cnpj: cnpj,
                address: address,
                description: description
            )
        }
    }
    
    private struct SignUpBody: Encodable {
        let name: String
        let email: String
        let password: String
        let cnpj: String
        let address: String
        let description: String
    }
}
