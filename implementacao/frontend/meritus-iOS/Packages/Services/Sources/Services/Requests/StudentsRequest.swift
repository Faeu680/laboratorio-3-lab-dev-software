//
//  StudentsRequest.swift
//  Services
//
//  Created by Arthur Porto on 02/11/25.
//

import Networking

enum StudentsRequest: APIRequest {
    case signUp(
        name: String,
        email: String,
        password: String,
        cpf: String,
        rg: String,
        address: String,
        course: String,
        institutionId: String
    )
    
    static let basePath = "/students"
    
    var path: String {
        switch self {
        case .signUp:
            return Self.basePath
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signUp:
            return .post
        }
    }
    
    var body: (any Encodable)? {
        switch self {
        case let .signUp(name, email, password, cpf, rg, address, course, institutionId):
            return SignUpBody(
                name: name,
                email: email,
                password: password,
                cpf: cpf,
                rg: rg,
                address: address,
                course: course,
                institutionId: institutionId
            )
        }
    }
    
    private struct SignUpBody: Encodable {
        let name: String
        let email: String
        let password: String
        let cpf: String
        let rg: String
        let address: String
        let course: String
        let institutionId: String
    }
}
