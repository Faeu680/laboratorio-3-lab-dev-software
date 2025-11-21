//
//  MakeTransferUseCaseProtocol.swift
//  Domain
//
//  Created by Arthur Porto on 21/11/25.
//

public protocol MakeTransferUseCaseProtocol: Sendable {
    func execute(_ transfer: MakeTransferModel) async throws(MakeTransferUseCaseError)
}
