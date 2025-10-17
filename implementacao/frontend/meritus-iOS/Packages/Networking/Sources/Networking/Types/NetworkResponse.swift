//
//  NetworkResponse.swift
//  Networking
//
//  Created by Arthur Porto on 17/10/25.
//

import Foundation

public struct NetworkResponse<T: Decodable & Sendable>: Decodable, Sendable {
    public let data: T
}
