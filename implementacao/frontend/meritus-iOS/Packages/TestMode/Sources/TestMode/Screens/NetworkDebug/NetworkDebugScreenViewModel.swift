//
//  NetworkDebugScreenViewModel.swift
//  TestMode
//
//  Created by Arthur Porto on 02/11/25.
//

import Foundation
import Combine
import Networking

@MainActor
public final class NetworkDebugScreenViewModel: ObservableObject {
    @Published private(set) var entries: [NetworkLogEntry] = []
    @Published var searchText: String = ""
    @Published var methodFilter: Set<String> = []
    @Published var statusFilter: ClosedRange<Int>? = nil

    private let store: NetworkDebugStoreProtocol
    private var task: Task<Void, Never>?

    public init(store: NetworkDebugStoreProtocol) {
        self.store = store
        task = Task { [weak self] in
            guard let self else { return }
            for await snapshot in await store.subscribe() {
                self.entries = snapshot
            }
        }
    }

    deinit { task?.cancel() }

    func clear() {
        Task { await store.clear() }
    }

    var filteredEntries: [NetworkLogEntry] {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return entries.filter { e in
            if !methodFilter.isEmpty && !methodFilter.contains(e.request.method) { return false }

            if let range = statusFilter {
                let code = e.response?.statusCode ?? -1
                if !range.contains(code) { return false }
            }

            if q.isEmpty { return true }
            let hay = [
                e.request.url.lowercased(),
                e.request.method.lowercased(),
                e.response?.body?.lowercased() ?? "",
                e.response?.errorDescription?.lowercased() ?? ""
            ].joined(separator: " ")
            return hay.contains(q)
        }
    }
}
