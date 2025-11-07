//
//  BenefitsRequest.swift
//  Services
//
//  Created by Arthur Porto on 07/11/25.
//

import Networking

enum BenefitsRequest: APIRequest {
    case createBenefit(
        name: String,
        description: String,
        photo: String,
        cost: Double
    )
    
    var scope: APIScope { .authenticated }
    
    var path: String {
        "/benefits"
    }
    
    var method: HTTPMethod {
        switch self {
        case .createBenefit:
            return .post
        }
    }
    
    var body: (any Encodable)? {
        switch self {
        case let .createBenefit(name, description, photo, cost):
            return CreateBenefitBody(
                name: name,
                description: description,
                photo: photo,
                cost: cost
            )
        }
    }
    
    private struct CreateBenefitBody: Encodable {
        let name: String
        let description: String
        let photo: String
        let cost: Double
    }
}
