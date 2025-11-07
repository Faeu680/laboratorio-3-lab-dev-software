//
//  RegisterCompanyModel.swift
//  Domain
//
//  Created by Arthur Porto on 07/11/25.
//

public struct RegisterCompanyModel {
    let name: String
    let email: String
    let password: String
    let cnpj: String
    let address: String
    let description: String
    
    public init(
        name: String,
        email: String,
        password: String,
        cnpj: String,
        address: String,
        description: String
    ) {
        self.name = name
        self.email = email
        self.password = password
        self.cnpj = cnpj
        self.address = address
        self.description = description
    }
}
