//
//  PresignedURLResponse.swift
//  Services
//
//  Created by Arthur Porto on 12/11/25.
//

import Domain
import Foundation

struct PresignedURLResponse: Decodable {
    let path: String
    let presignedUrl: String
    
    func toDomain() -> PresignedURLModel? {
        guard let presignedUrl = URL(string: presignedUrl) else {
            return nil
        }
        
        return PresignedURLModel(
            path: path,
            presignedUrl: presignedUrl
        )
    }
}
