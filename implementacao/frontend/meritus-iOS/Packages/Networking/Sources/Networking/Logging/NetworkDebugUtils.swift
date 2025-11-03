//
//  NetworkDebugUtils.swift
//  Networking
//
//  Created by Arthur Porto on 02/11/25.
//

import Foundation
import Alamofire

enum NetworkDebugUtils {
    static let redactedHeaderKeys: Set<String> = ["authorization", "proxy-authorization", "api-key", "x-api-key", "x-auth-token"]
    static let maxBodyPreviewBytes: Int = 64 * 1024
    
    static func redact(headers: HTTPHeaders?) -> [String: String] {
        guard let headers else { return [:] }
        var result: [String: String] = [:]
        for h in headers {
            if redactedHeaderKeys.contains(h.name.lowercased()) {
                result[h.name] = "•••• REDACTED ••••"
            } else {
                result[h.name] = h.value
            }
        }
        return result
    }
    
    static func headers(from urlRequest: URLRequest?) -> [String: String] {
        guard let all = urlRequest?.allHTTPHeaderFields else { return [:] }
        var result: [String: String] = [:]
        for (k, v) in all {
            if redactedHeaderKeys.contains(k.lowercased()) {
                result[k] = "•••• REDACTED ••••"
            } else {
                result[k] = v
            }
        }
        return result
    }
    
    static func bodyString(from urlRequest: URLRequest?) -> String? {
        guard let req = urlRequest else { return nil }
        if let data = req.httpBody {
            return previewString(from: data, contentType: req.value(forHTTPHeaderField: "Content-Type"))
        }
        if req.httpBodyStream != nil {
            return "(httpBodyStream – não inspecionado)"
        }
        return nil
    }
    
    static func previewString(from data: Data, contentType: String?) -> String {
        let slice = data.prefix(maxBodyPreviewBytes)
        if let type = contentType?.lowercased(), type.contains("application/json") {
            // tentar pretty-print
            if let obj = try? JSONSerialization.jsonObject(with: slice),
               let pretty = try? JSONSerialization.data(withJSONObject: obj, options: [.prettyPrinted]),
               let s = String(data: pretty, encoding: .utf8) {
                return s
            }
        }
        return String(data: slice, encoding: .utf8) ?? "(\(slice.count) bytes binários)"
    }
    
    static func responseBodyString(from data: Data?, contentType: String?) -> String? {
        guard let data else { return nil }
        return previewString(from: data, contentType: contentType)
    }
}
