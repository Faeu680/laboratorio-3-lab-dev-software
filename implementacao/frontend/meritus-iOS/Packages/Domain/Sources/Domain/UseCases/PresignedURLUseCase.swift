//
//  PresignedURLUseCase.swift
//  Domain
//
//  Created by Arthur Porto on 12/11/25.
//

final class PresignedURLUseCase: PresignedURLUseCaseProtocol {
    private let service: UploadServiceProtocol
    
    init(service: UploadServiceProtocol) {
        self.service = service
    }
    
    func execute(
        originalName: String,
        mimeType: String
    ) async throws(PresignedURLUseCaseError) -> PresignedURLModel {
        do {
            let presignedURL = try await service.presignedURL(
                originalName: originalName,
                mimeType: mimeType
            )
            return presignedURL
        } catch {
            throw .todo
        }
    }
}
