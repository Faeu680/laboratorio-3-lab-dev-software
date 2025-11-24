//
//  BiometryError.swift
//  Meritus
//
//  Created by Arthur Porto on 23/11/25.
//

public enum BiometryError: Error {
    case biometryNotAvailable
    case biometryNotEnrolled
    case failed
    case cancelled
}
