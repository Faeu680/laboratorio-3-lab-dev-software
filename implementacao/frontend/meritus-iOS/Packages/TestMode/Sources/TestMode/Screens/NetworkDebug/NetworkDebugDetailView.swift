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
    
    @State private var showCurlPicker = false
    @State private var copied = false
    
    public init(entry: NetworkLogEntry) { self.entry = entry }
    
    private var curlShell: String?   { entry.request.curlShell }
    private var curlPostman: String? { entry.request.curlPostman }
    private var curlPreview: String  { curlShell ?? curlPostman ?? "—" }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                section("Request") {
                    kv("Method", entry.request.method)
                    kv("URL", entry.request.url)
                    kv("Headers", pretty(entry.request.headers))
                    kv("Body", entry.request.body ?? "—", monospaced: true)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("cURL (preview)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            Text(curlPreview)
                                .font(.footnote)
                                .fontDesign(.monospaced)
                                .textSelection(.enabled)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(10)
                                .background(Color.secondary.opacity(0.07))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        
                        HStack {
                            Button {
                                showCurlPicker = true
                            } label: {
                                Label(copied ? "Copiado!" : "Copiar cURL…", systemImage: copied ? "checkmark.circle" : "doc.on.doc")
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                            
                            Spacer()
                            
                            Menu {
                                if let shell = curlShell {
                                    ShareLink("Compartilhar (Terminal)", item: shell)
                                }
                                if let pm = curlPostman {
                                    ShareLink("Compartilhar (Postman)", item: pm)
                                }
                            } label: {
                                Image(systemName: "square.and.arrow.up")
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                        }
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
        .confirmationDialog("Copiar cURL como…", isPresented: $showCurlPicker, titleVisibility: .visible) {
            if let shell = curlShell {
                Button("Terminal") { copy(shell) }
            }
            if let pm = curlPostman {
                Button("Postman") { copy(pm) }
            }
            Button("Cancelar", role: .cancel) { }
        }
    }
    
    // MARK: - Helpers
    
    private func copy(_ text: String) {
        UIPasteboard.general.string = text
        copied = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { copied = false }
    }
    
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
                    copy(value)
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
