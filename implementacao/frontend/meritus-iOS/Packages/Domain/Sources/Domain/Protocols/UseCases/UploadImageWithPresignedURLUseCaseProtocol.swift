//
//  UploadImageWithPresignedURLUseCaseProtocol.swift
//  Domain
//
//  Created by Arthur Porto on 13/11/25.
//

import Foundation

public protocol UploadImageWithPresignedURLUseCaseProtocol: Sendable {
    func execute(
        with url: URL,
        for image: Data
    ) async throws(UploadImageWithPresignedURLUseCaseError)
}
