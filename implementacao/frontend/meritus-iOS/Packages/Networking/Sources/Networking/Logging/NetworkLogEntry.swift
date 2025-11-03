//
//  NetworkLogEntry.swift
//  Networking
//
//  Created by Arthur Porto on 02/11/25.
//

import Foundation
import Alamofire

public struct NetworkLogEntry: Identifiable, Codable, Sendable {
    public let id: NetworkLogID
    public let requestId: UUID
    public var request: NetworkRequestInfo
    public var response: NetworkResponseInfo?
    public var timing: NetworkTiming
}
