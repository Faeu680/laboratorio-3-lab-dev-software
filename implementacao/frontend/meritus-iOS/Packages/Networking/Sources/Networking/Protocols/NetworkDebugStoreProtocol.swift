//
//  NetworkDebugStoreProtocol.swift
//  Networking
//
//  Created by Arthur Porto on 02/11/25.
//

import Foundation

public protocol NetworkDebugStoreProtocol: Actor {
    func append(_ entry: NetworkLogEntry)
    func clear()
    func snapshot() -> [NetworkLogEntry]
    func updateMetrics(requestId: UUID, summary: String?)
    func setResponse(requestId: UUID, response: NetworkResponseInfo)
    func subscribe() -> AsyncStream<[NetworkLogEntry]>
}
