//
//  NetworkClientProtocol.swift
//  Networking
//
//  Created by Arthur Porto on 17/10/25.
//

import Foundation

public protocol NetworkClientProtocol: Sendable {
    func request<T: Decodable>(_ endpoint: some Request) async throws(NetworkError) -> NetworkResponse<T>
    func request(_ endpoint: some Request) async throws(NetworkError)
}
