//
//  UploadRequest.swift
//  Services
//
//  Created by Arthur Porto on 12/11/25.
//

import Networking

enum UploadRequest: APIRequest {
    case presignedURL(
        originalName: String,
        mimeType: String,
    )
    
    static let basePath = "/upload"
    
    var scope: APIScope {
        switch self {
        case .presignedURL:
            return .unauthenticated
        }
    }
    
    var path: String {
        switch self {
        case .presignedURL:
            return Self.basePath + "presigned-url"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .presignedURL:
            return .post
        }
    }
    
    var body: (any Encodable)? {
        switch self {
        case let .presignedURL(originalName, mimeType):
            return PresignedURLBody(
                originalName: originalName,
                mimeType: mimeType
            )
        }
    }
    
    private struct PresignedURLBody: Encodable {
        let originalName: String
        let mimeType: String
    }
}
