//
//  UploadService.swift
//  Services
//
//  Created by Arthur Porto on 12/11/25.
//

import Foundation
import Domain
import Networking

final class UploadService: UploadServiceProtocol {
    
    private let network: NetworkClientProtocol

    init(network: NetworkClientProtocol) {
        self.network = network
    }
    
    func presignedURL(
        originalName: String,
        mimeType: String
    ) async throws(ServiceError) -> PresignedURLModel {
        let request = UploadRequest.presignedURL(
            originalName: originalName,
            mimeType: mimeType
        )
        
        let response: NetworkResponse<PresignedURLResponse>
        
        do {
            response = try await network.request(request)
        } catch {
            throw ServiceError(from: error)
        }
        
        guard let mapped = response.data.toDomain() else {
            throw .invalidURL
        }
        
        return mapped
    }
    
    func upload(
        with url: URL,
        for image: Data
    ) async throws(ServiceError) {
        let request = UploadRequest.uploadImage(
            url: url,
            image: image
        )
        
        do {
            try await network.request(request)
        } catch {
            throw ServiceError(from: error)
        }
    }
}
