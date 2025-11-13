//
//  PresignedURLModel.swift
//  Domain
//
//  Created by Arthur Porto on 12/11/25.
//

public struct PresignedURLModel {
    public let path: String
    public let presignedUrl: String
    
    public init(
        path: String,
        presignedUrl: String
    ) {
        self.path = path
        self.presignedUrl = presignedUrl
    }
}
