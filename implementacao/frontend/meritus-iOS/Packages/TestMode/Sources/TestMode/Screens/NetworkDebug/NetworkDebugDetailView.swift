//
//  NetworkDebugDetailView.swift
//  TestMode
//
//  Created by Arthur Porto on 02/11/25.
//

import SwiftUI
import Networking

struct NetworkDebugDetailView: View {
    let entry: NetworkLogEntry

    public init(entry: NetworkLogEntry) { self.entry = entry }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                section("Request") {
                    kv("Method", entry.request.method)
                    kv("URL", entry.request.url)
                    kv("Headers", pretty(entry.request.headers))
                    kv("Body", entry.request.body ?? "—", monospaced: true)
                    if let curl = entry.request.curl {
                        kv("cURL", curl, monospaced: true)
                    }
                }

                section("Response") {
                    kv("Status", entry.response?.statusCode.map(String.init) ?? "—")
                    kv("Headers", pretty(entry.response?.headers ?? [:]))
                    kv("Body", entry.response?.body ?? "—", monospaced: true)
                    if let err = entry.response?.errorDescription {
                        kv("Error", err, monospaced: true)
                    }
                }

                section("Timing") {
                    kv("Start", entry.timing.startAt.formatted())
                    kv("End", entry.timing.endAt?.formatted() ?? "—")
                    kv("Duration", entry.timing.durationMs.map { String(format: "%.0f ms", $0) } ?? "—")
                    kv("Metrics", entry.timing.metricsSummary ?? "—", monospaced: true)
                }
            }
            .padding()
        }
        .navigationTitle("Detalhe")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Helpers UI

    @ViewBuilder
    private func section(_ title: String, @ViewBuilder _ content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.headline)
            VStack(alignment: .leading, spacing: 8, content: content)
                .padding()
                .background(Color.secondary.opacity(0.07))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    @ViewBuilder
    private func kv(_ key: String, _ value: String, monospaced: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(key).font(.caption).foregroundStyle(.secondary)
            HStack(alignment: .top) {
                (monospaced ? Text(value).fontDesign(.monospaced) : Text(value))
                    .font(.footnote)
                    .textSelection(.enabled)
                Spacer(minLength: 8)
                Button {
                    UIPasteboard.general.string = value
                } label: {
                    Image(systemName: "doc.on.doc")
                }
                .buttonStyle(.plain)
                .help("Copiar")
            }
        }
    }

    private func pretty(_ dict: [String: String]) -> String {
        dict.map { "\($0): \($1)" }.sorted().joined(separator: "\n")
    }
}
