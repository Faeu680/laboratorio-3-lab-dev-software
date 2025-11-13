//
//  UploadServiceProtocol.swift
//  Domain
//
//  Created by Arthur Porto on 12/11/25.
//

public protocol UploadServiceProtocol: Sendable {
    func presignedURL(
        originalName: String,
        mimeType: String
    ) async throws(ServiceError) -> PresignedURLModel
}
