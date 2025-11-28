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
        cost: String
    )
    
    case getBenefits
    
    case getMyBenefits
    
    static let basePath = "/benefits"
    
    var scope: APIScope { .authenticated }
    
    var path: String {
        switch self {
        case .createBenefit, .getBenefits:
            Self.basePath
        case .getMyBenefits:
            Self.basePath + "/my-benefits"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createBenefit:
            return .post
        case .getBenefits, .getMyBenefits:
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
        case .getBenefits, .getMyBenefits:
            return .none
        }
    }
    
    private struct CreateBenefitBody: Encodable {
        let name: String
        let description: String
        let photo: String
        let cost: String
    }
}
