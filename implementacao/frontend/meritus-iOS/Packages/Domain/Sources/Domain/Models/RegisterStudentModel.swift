//
//  RegisterStudentModel.swift
//  Domain
//
//  Created by Arthur Porto on 02/11/25.
//

import Foundation

public struct RegisterStudentModel {
    let name: String
    let email: String
    let password: String
    let cpf: String
    let rg: String
    let address: String
    let course: String
    let institutionId: String
    
    public init(
        name: String,
        email: String,
        password: String,
        cpf: String,
        rg: String,
        address: String,
        course: String,
        institutionId: String
    ) {
        self.name = name
        self.email = email
        self.password = password
        self.cpf = cpf
        self.rg = rg
        self.address = address
        self.course = course
        self.institutionId = institutionId
    }
}
