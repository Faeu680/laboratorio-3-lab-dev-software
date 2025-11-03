//
//  NetworkDebugLogger.swift
//  Networking
//
//  Created by Arthur Porto on 02/11/25.
//

import Foundation
import Alamofire

final class NetworkDebugLogger: EventMonitor {
    private let store: NetworkDebugStoreProtocol
    
    init(store: NetworkDebugStoreProtocol) {
        self.store = store
    }
    
    func requestDidResume(_ request: Alamofire.Request) {
        guard let urlRequest = request.request else {
            print("⚠️ [NetworkDebugLogger] request.request == nil")
            return
        }
        
        let url = urlRequest.url?.absoluteString ?? "(desconhecida)"
        let method = urlRequest.httpMethod ?? "GET"
        
        let entry = NetworkLogEntry(
            id: .init(),
            requestId: request.id,
            request: .init(
                method: method,
                url: url,
                headers: NetworkDebugUtils.headers(from: urlRequest),
                body: NetworkDebugUtils.bodyString(from: urlRequest),
                curlShell: NetworkDebugUtils.curl(from: urlRequest, compact: false),
                curlPostman: NetworkDebugUtils.curl(from: urlRequest, compact: true)
            ),
            response: nil,
            timing: .init(startAt: Date(), endAt: nil, durationMs: nil, metricsSummary: nil)
        )
        
        Task { await store.append(entry) }
    }
    
    func request(_ request: Request, didGather metrics: URLSessionTaskMetrics) {
        let summary = summarize(metrics: metrics)
        Task { await store.updateMetrics(requestId: request.id, summary: summary) }
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        let status = response.response?.statusCode
        let headers = response.response.map { HTTPHeaders($0.headers.dictionary) }
        let contentType = response.response?.value(forHTTPHeaderField: "Content-Type")
        let bodyStr = NetworkDebugUtils.responseBodyString(from: response.data, contentType: contentType)
        
        let errorDesc: String? = response.error.map { String(describing: $0) }
        
        let resp = NetworkResponseInfo(
            statusCode: status,
            headers: NetworkDebugUtils.redact(headers: headers),
            body: bodyStr,
            errorDescription: errorDesc
        )
        
        Task { await store.setResponse(requestId: request.id, response: resp) }
    }
    
    private func summarize(metrics: URLSessionTaskMetrics) -> String {
        let total = metrics.taskInterval.duration * 1000
        var parts: [String] = []
        for (i, t) in metrics.transactionMetrics.enumerated() {
            let host = t.request.url?.host ?? "-"
            parts.append("#\(i+1) \(host) proto=\(t.networkProtocolName ?? "-") fetch=\(t.resourceFetchType.rawValue)")
        }
        return String(format: "task=%.0fms | %@", total, parts.joined(separator: " | "))
    }
}
