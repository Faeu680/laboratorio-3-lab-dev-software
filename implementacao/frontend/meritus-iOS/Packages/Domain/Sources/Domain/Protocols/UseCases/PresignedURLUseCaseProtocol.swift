//
//  PresignedURLUseCaseProtocol.swift
//  Domain
//
//  Created by Arthur Porto on 12/11/25.
//

public protocol PresignedURLUseCaseProtocol: Sendable {
    func execute(
        originalName: String,
        mimeType: String
    ) async throws(PresignedURLUseCaseError) -> PresignedURLModel
}
