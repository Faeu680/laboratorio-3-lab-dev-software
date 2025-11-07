//
//  NetworkDebugUtils.swift
//  Networking
//
//  Created by Arthur Porto on 02/11/25.
//

import Foundation
import Alamofire

enum NetworkDebugUtils {
    static let redactedHeaderKeys: Set<String> = [
        "authorization", "proxy-authorization", "api-key", "x-api-key", "x-auth-token"
    ]
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
    
    static func prettyJSONString(from data: Data, contentType: String?) -> String? {
        if let type = contentType?.lowercased(), type.contains("application/json") {
            if let obj = try? JSONSerialization.jsonObject(with: data),
               let pretty = try? JSONSerialization.data(withJSONObject: obj, options: [.prettyPrinted]),
               var s = String(data: pretty, encoding: .utf8) {
                s = s.replacingOccurrences(of: "\\/", with: "/")
                return s
            }
        }
        
        return String(data: data, encoding: .utf8)
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
    
    static func responseBodyString(from data: Data?, contentType: String?) -> String? {
        guard let data else { return nil }
        return previewString(from: data, contentType: contentType)
    }
    
    private static func previewString(from data: Data, contentType: String?) -> String {
        let slice = data.prefix(maxBodyPreviewBytes)
        if let s = prettyJSONString(from: Data(slice), contentType: contentType) {
            return s
        }
        return String(data: slice, encoding: .utf8) ?? "(\(slice.count) bytes binários)"
    }
    
    private static func shellQuote(_ s: String) -> String {
        "'" + s.replacingOccurrences(of: "'", with: "'\\''") + "'"
    }
    
    static func curl(from req: URLRequest, compact: Bool = false) -> String {
        var lines: [String] = []
        
        if compact {
            var parts: [String] = ["curl", "-v"]
            
            if let method = req.httpMethod {
                parts += ["-X", method]
            }
            
            let hdrs = req.allHTTPHeaderFields ?? [:]
            for (k, v) in hdrs.sorted(by: { $0.key < $1.key }) {
                let value = redactedHeaderKeys.contains(k.lowercased()) ? "•••• REDACTED ••••" : v
                parts += ["-H", "'\(k): \(value)'"]
            }
            
            if let body = req.httpBody,
               let bodyStr = prettyJSONString(from: body, contentType: req.value(forHTTPHeaderField: "Content-Type")) {
                parts += ["-d", "'\(bodyStr.replacingOccurrences(of: "'", with: "\\'"))'"]
            }
            
            if let url = req.url?.absoluteString {
                parts.append("'\(url)'")
            }
            
            return parts.joined(separator: " ")
        }
        
        lines.append("$ curl -v \\")
        if let method = req.httpMethod {
            lines.append("\t-X \(method) \\")
        }
        let hdrs = req.allHTTPHeaderFields ?? [:]
        for (k, v) in hdrs.sorted(by: { $0.key < $1.key }) {
            let value = redactedHeaderKeys.contains(k.lowercased()) ? "•••• REDACTED ••••" : v
            lines.append("\t-H '\(k): \(value)' \\")
        }
        if let body = req.httpBody,
           let bodyStr = prettyJSONString(from: body, contentType: req.value(forHTTPHeaderField: "Content-Type")) {
            lines.append("\t-d '\(bodyStr.replacingOccurrences(of: "'", with: "\\'"))' \\")
        }
        lines.append("\t'\(req.url?.absoluteString ?? "")'")
        return lines.joined(separator: "\n")
    }
}
