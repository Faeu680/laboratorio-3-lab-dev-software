//
//  UploadService.swift
//  Services
//
//  Created by Arthur Porto on 12/11/25.
//

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
        
        do {
            let response: NetworkResponse<PresignedURLResponse> = try await network.request(request)
            let mapped = response.data.toDomain()
            return mapped
        } catch {
            throw ServiceError(from: error)
        }
    }
}
