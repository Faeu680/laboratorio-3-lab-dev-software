//
//  CreateBenefitUseCaseError.swift
//  Domain
//
//  Created by Arthur Porto on 07/11/25.
//

public enum CreateBenefitUseCaseError: Error {
    case unauthorized
    case acessDeniedOnlyBusiness
    case companyNotFound
    case unknown
}
