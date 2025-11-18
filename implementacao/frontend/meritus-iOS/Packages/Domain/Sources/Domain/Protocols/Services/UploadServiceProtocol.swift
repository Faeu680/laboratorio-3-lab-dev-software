//
//  UploadServiceProtocol.swift
//  Domain
//
//  Created by Arthur Porto on 12/11/25.
//

import Foundation

public protocol UploadServiceProtocol: Sendable {
    func presignedURL(
        originalName: String,
        mimeType: String
    ) async throws(ServiceError) -> PresignedURLModel
    
    func upload(
        with url: URL,
        for image: Data
    ) async throws(ServiceError)
}
