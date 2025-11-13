//
//  PresignedURLResponse.swift
//  Services
//
//  Created by Arthur Porto on 12/11/25.
//

import Domain

struct PresignedURLResponse: Decodable {
    let path: String
    let presignedUrl: String
    
    func toDomain() -> PresignedURLModel {
        PresignedURLModel(
            path: path,
            presignedUrl: presignedUrl
        )
    }
}
