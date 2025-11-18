//
//  UploadRequest.swift
//  Services
//
//  Created by Arthur Porto on 12/11/25.
//

import Foundation
import Networking

enum UploadRequest: APIRequest {
    case presignedURL(
        originalName: String,
        mimeType: String,
    )
    
    case uploadImage(
        url: URL,
        image: Data
    )
    
    static let basePath = "/upload"
    
    var contentType: ContentType {
        switch self {
        case .presignedURL:
            return .json
        case .uploadImage:
            return .image(.jpeg)
        }
    }
    
    var scope: APIScope {
        switch self {
        case .presignedURL:
            return .authenticated
        case .uploadImage:
            return .unauthenticated
        }
    }
    
    var usePathAsURL: Bool {
        switch self {
        case .presignedURL:
            return false
        case .uploadImage:
            return true
        }
    }
    
    var path: String {
        switch self {
        case .presignedURL:
            return Self.basePath + "/presigned-url"
        case let .uploadImage(url, _):
            return url.absoluteString
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .presignedURL:
            return .post
        case .uploadImage:
            return .put
        }
    }
    
    var body: BodyType {
        switch self {
        case let .presignedURL(originalName, mimeType):
            return .json(
                PresignedURLBody(
                    originalName: originalName,
                    mimeType: mimeType
                )
            )
        case let .uploadImage(_, image):
            return .data(image)
        }
    }
    
    private struct PresignedURLBody: Encodable {
        let originalName: String
        let mimeType: String
    }
}
