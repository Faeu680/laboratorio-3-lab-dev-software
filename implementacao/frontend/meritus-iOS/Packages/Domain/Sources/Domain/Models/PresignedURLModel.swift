//
//  PresignedURLModel.swift
//  Domain
//
//  Created by Arthur Porto on 12/11/25.
//

import Foundation

public struct PresignedURLModel {
    public let path: String
    public let presignedUrl: URL
    
    public init(
        path: String,
        presignedUrl: URL
    ) {
        self.path = path
        self.presignedUrl = presignedUrl
    }
}
