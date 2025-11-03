//
//  BootstrapSessionUseCaseProtocol.swift
//  Domain
//
//  Created by Arthur Porto on 31/10/25.
//


public protocol BootstrapSessionUseCaseProtocol: Sendable {
    func execute() async throws(BootstrapSessionUseCaseError)
}
