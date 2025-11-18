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
    
    case getBenefits
    
    var scope: APIScope { .authenticated }
    
    var path: String { "/benefits" }
    
    var method: HTTPMethod {
        switch self {
        case .createBenefit:
            return .post
        case .getBenefits:
            return .get
        }
    }
    
    var body: BodyType {
        switch self {
        case let .createBenefit(name, description, photo, cost):
            return .json(
                CreateBenefitBody(
                    name: name,
                    description: description,
                    photo: photo,
                    cost: cost
                )
            )
        case .getBenefits:
            return .none
        }
    }
    
    private struct CreateBenefitBody: Encodable {
        let name: String
        let description: String
        let photo: String
        let cost: Double
    }
}
