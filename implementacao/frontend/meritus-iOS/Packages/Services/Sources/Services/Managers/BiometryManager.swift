//
//  BiometryManager.swift
//  Meritus
//
//  Created by Arthur Porto on 23/11/25.
//

import Foundation
import LocalAuthentication
import Domain

final class BiometryManager: BiometryManagerProtocol {
    
    private var context = LAContext()
    
    // MARK: - Public Methods
    
    func isBiometryAvailable() -> Bool {
        self.context = LAContext()
        
        var error: NSError?
        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        return canEvaluate
    }
    
    func biometryType() -> BiometryType {
        switch context.biometryType {
        case .faceID:
            return .faceID
        case .touchID:
            return .touchID
        default:
            return .none
        }
    }
    
    @MainActor
    func authenticate(reason: String) async throws(BiometryError) {
        guard isBiometryAvailable() else {
            throw .biometryNotAvailable
        }
        
        do {
            try await withCheckedThrowingContinuation { continuation in
                context.evaluatePolicy(
                    .deviceOwnerAuthenticationWithBiometrics,
                    localizedReason: reason
                ) { success, error in
                    if success {
                        continuation.resume(returning: ())
                        return
                    }
                    
                    if let error {
                        continuation.resume(throwing: error)
                        return
                    }
                    
                    continuation.resume(throwing: BiometryError.failed)
                }
            }
        } catch {
            throw mapError(error)
        }
    }
    
    // MARK: - Private Methods
    
    private func mapError(_ error: Error) -> BiometryError {
        if let biometryError = error as? BiometryError {
            return biometryError
        }
        
        if let laError = error as? LAError {
            switch laError.code {
            case .biometryNotAvailable:
                return .biometryNotAvailable
            case .biometryNotEnrolled:
                return .biometryNotEnrolled
            case .userCancel, .appCancel, .systemCancel:
                return .cancelled
            default:
                return .failed
            }
        }
        
        return .failed
    }
}
