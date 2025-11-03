//
//  NetworkDebugScreenView.swift
//  TestMode
//
//  Created by Arthur Porto on 02/11/25.
//

import SwiftUI
import Networking

public struct NetworkDebugScreenView: View {
    @StateObject private var viewModel: NetworkDebugScreenViewModel

    public init(viewModel: NetworkDebugScreenViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationStack {
            List {
                if viewModel.filteredEntries.isEmpty {
                    ContentUnavailableView(
                        "Sem logs ainda",
                        systemImage: "network",
                        description: Text("Faça alguma request ou desabilite filtros.")
                    )
                } else {
                    ForEach(viewModel.filteredEntries) { entry in
                        NavigationLink {
                            NetworkDebugDetailView(entry: entry)
                        } label: {
                            Row(entry: entry)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Network Debug")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        // Métodos
                        Section("Métodos") {
                            MethodToggle(title: "GET",   selection: $viewModel.methodFilter)
                            MethodToggle(title: "POST",  selection: $viewModel.methodFilter)
                            MethodToggle(title: "PUT",   selection: $viewModel.methodFilter)
                            MethodToggle(title: "PATCH", selection: $viewModel.methodFilter)
                            MethodToggle(title: "DELETE",selection: $viewModel.methodFilter)
                            Button("Limpar métodos") { viewModel.methodFilter.removeAll() }
                        }
                        // Status
                        Section("Status") {
                            Button("2xx (sucesso)") { viewModel.statusFilter = 200...299 }
                            Button("4xx (cliente)") { viewModel.statusFilter = 400...499 }
                            Button("5xx (servidor)") { viewModel.statusFilter = 500...599 }
                            Button("Qualquer") { viewModel.statusFilter = nil }
                        }
                        // Outros
                        Section {
                            Button(role: .destructive) {
                                viewModel.clear()
                            } label: {
                                Label("Limpar logs", systemImage: "trash")
                            }
                        }
                    } label: {
                        Label("Filtros", systemImage: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "URL, body, erro…")
        }
    }
}

// MARK: - Row

private struct Row: View {
    let entry: NetworkLogEntry

    var statusColor: Color {
        guard let code = entry.response?.statusCode else { return .secondary }
        switch code {
        case 200..<300: return .green
        case 300..<400: return .blue
        case 400..<500: return .orange
        default:        return .red
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                CapsuleLabel(text: entry.request.method)
                if let code = entry.response?.statusCode {
                    Text(String(code))
                        .font(.caption2).bold()
                        .padding(.horizontal, 6).padding(.vertical, 2)
                        .background(statusColor.opacity(0.15))
                        .foregroundStyle(statusColor)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                } else {
                    Text("—").font(.caption2).foregroundStyle(.secondary)
                }
                Spacer()
                if let ms = entry.timing.durationMs {
                    Text(String(format: "%.0f ms", ms))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            Text(entry.request.url)
                .font(.footnote)
                .lineLimit(2)

            if let err = entry.response?.errorDescription {
                Text(err)
                    .font(.caption2)
                    .foregroundStyle(.red)
                    .lineLimit(2)
            }
        }
    }
}

private struct CapsuleLabel: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.caption2).bold()
            .padding(.horizontal, 6).padding(.vertical, 2)
            .background(Color.secondary.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

private struct MethodToggle: View {
    let title: String
    @Binding var selection: Set<String>

    var body: some View {
        Button {
            if selection.contains(title) { selection.remove(title) }
            else { selection.insert(title) }
        } label: {
            HStack {
                Text(title)
                Spacer()
                if selection.contains(title) {
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}
