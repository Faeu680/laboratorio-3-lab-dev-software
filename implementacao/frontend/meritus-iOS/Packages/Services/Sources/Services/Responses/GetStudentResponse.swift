//
//  GetStudentResponse.swift
//  Services
//
//  Created by Arthur Porto on 21/11/25.
//

import Domain

struct GetStudentResponse: Decodable {
    let id: String
    let name: String
    let email: String
    
    func toDomain() -> StudentModel {
        StudentModel(
            id: id,
            name: name,
            email: email
        )
    }
}
