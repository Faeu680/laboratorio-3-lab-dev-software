//
//  NetworkDebugStore.swift
//  Networking
//
//  Created by Arthur Porto on 02/11/25.
//

import Foundation
import Combine

actor NetworkDebugStore: NetworkDebugStoreProtocol {
    private(set) var entries: [NetworkLogEntry] = []
    private let maxEntries = 200
    private var continuations: [UUID: AsyncStream<[NetworkLogEntry]>.Continuation] = [:]

    func append(_ entry: NetworkLogEntry) {
        entries.insert(entry, at: 0)
        if entries.count > maxEntries { entries.removeLast(entries.count - maxEntries) }
        broadcast()
    }

    func clear() {
        entries.removeAll()
        broadcast()
    }

    func snapshot() -> [NetworkLogEntry] { entries }

    func updateMetrics(requestId: UUID, summary: String?) {
        guard let idx = entries.firstIndex(where: { $0.requestId == requestId }) else { return }
        entries[idx].timing.metricsSummary = summary
        broadcast()
    }
    
    func setResponse(requestId: UUID, response: NetworkResponseInfo) {
        guard let idx = entries.firstIndex(where: { $0.requestId == requestId }) else { return }
        entries[idx].response = response
        entries[idx].timing.endAt = Date()
        if let end = entries[idx].timing.endAt {
            entries[idx].timing.durationMs = end.timeIntervalSince(entries[idx].timing.startAt) * 1000
        }
        broadcast()
    }

    func subscribe() -> AsyncStream<[NetworkLogEntry]> {
        let id = UUID()
        return AsyncStream { continuation in
            self.addContinuation(id: id, continuation: continuation)
            continuation.onTermination = { [id, weak self] _ in
                Task { await self?.removeContinuation(id: id) }
            }
        }
    }

    private func addContinuation(id: UUID, continuation: AsyncStream<[NetworkLogEntry]>.Continuation) {
        continuations[id] = continuation
        continuation.yield(entries)
    }

    private func removeContinuation(id: UUID) {
        continuations.removeValue(forKey: id)
    }

    private func broadcast() {
        let snapshot = entries
        for (_, c) in continuations {
            c.yield(snapshot)
        }
    }
}
