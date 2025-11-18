//
//  SigninRequest.swift
//  Services
//
//  Created by Arthur Porto on 17/10/25.
//

import Networking

struct SigninRequest: APIRequest {
    private let email: String
    private let password: String
    
    let path: String = "/auth/signin"
    let method: HTTPMethod = .post
    let scope: APIScope = .unauthenticated
    
    init(
        email: String,
        password: String
    ) {
        self.email = email
        self.password = password
    }
    
    var body: BodyType {
        return .json(
            Body(
                email: email,
                password: password
            )
        )
    }
    
    private struct Body: Encodable {
        let email: String
        let password: String
    }
}
