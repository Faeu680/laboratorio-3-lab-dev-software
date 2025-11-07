//
//  Array+Extensions.swift
//  Services
//
//  Created by Arthur Porto on 07/11/25.
//

import Domain

extension Array where Element == GetBenefitsResponse {
    func toDomain() -> [BenefitModel] {
        map { $0.toDomain() }
    }
}
