//
//  NetworkTiming.swift
//  Networking
//
//  Created by Arthur Porto on 02/11/25.
//

import Foundation

public struct NetworkTiming: Codable, Sendable {
    public let startAt: Date
    public var endAt: Date?
    public var durationMs: Double?
    public var metricsSummary: String?
}
