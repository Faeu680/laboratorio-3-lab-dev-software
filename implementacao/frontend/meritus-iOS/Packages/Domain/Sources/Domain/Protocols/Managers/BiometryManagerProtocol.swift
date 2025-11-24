//
//  BiometryManagerProtocol.swift
//  Domain
//
//  Created by Arthur Porto on 23/11/25.
//

public protocol BiometryManagerProtocol {
    func isBiometryAvailable() -> Bool
    func biometryType() -> BiometryType
    
    @MainActor
    func authenticate(reason: String) async throws(BiometryError)
}
