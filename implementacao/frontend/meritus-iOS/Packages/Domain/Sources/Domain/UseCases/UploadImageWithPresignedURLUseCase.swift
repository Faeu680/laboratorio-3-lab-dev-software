//
//  UploadImageWithPresignedURLUseCase.swift
//  Domain
//
//  Created by Arthur Porto on 13/11/25.
//

import Foundation

final class UploadImageWithPresignedURLUseCase: UploadImageWithPresignedURLUseCaseProtocol {
    
    private let service: UploadServiceProtocol
    
    init(service: UploadServiceProtocol) {
        self.service = service
    }
    
    func execute(
        with url: URL,
        for image: Data
    ) async throws(UploadImageWithPresignedURLUseCaseError) {
        do {
            try await service.upload(with: url, for: image)
        } catch {
            throw .todo
        }
    }
}
