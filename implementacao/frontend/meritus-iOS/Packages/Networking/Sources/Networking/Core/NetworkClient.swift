//
//  NetworkClient.swift
//  Networking
//
//  Created by Arthur Porto on 17/10/25.
//

import Foundation
import Alamofire

final class NetworkClient: NetworkClientProtocol {
    private let session: Session
    private let decoder = JSONDecoder()
    
    init(session: Session) {
        self.session = session
    }
    
    func request<T: Decodable>(_ request: some APIRequest) async throws(NetworkError) -> NetworkResponse<T> {
        try await runInBackground {
            try await self.performRequest(request)
        }
    }
    
    func request(_ request: some APIRequest) async throws(NetworkError) {
        try await runInBackground {
            try await self.performVoidRequest(request)
        }
    }
    
    // MARK: - Private Methods
    
    private func runInBackground<T>(
        _ operation: @escaping @Sendable () async throws -> T
    ) async throws(NetworkError) -> T where T: Sendable {
        do {
            return try await Task.detached(priority: .userInitiated) {
                try await operation()
            }.value
        } catch let error as NetworkError {
            throw error
        } catch {
            throw .unknown
        }
    }
    
    private func performRequest<T: Decodable>(_ request: some APIRequest) async throws(NetworkError) -> NetworkResponse<T> {
        let urlRequest: URLRequest
        do {
            urlRequest = try request.asURLRequest()
        } catch let e as NetworkError {
            throw e
        } catch {
            throw .unknown
        }
        
        let dr = await session.request(urlRequest)
            .validate(statusCode: 200..<300)
            .serializingDecodable(NetworkResponse<T>.self, decoder: decoder)
            .response
        
        if let afError = dr.error {
            throw mapAFError(afError, dr.response, dr.data)
        }
        
        guard let value = dr.value else {
            throw .invalidResponse
        }
        return value
    }
    
    private func performVoidRequest(_ request: some APIRequest) async throws(NetworkError) {
        let urlRequest: URLRequest
        do {
            urlRequest = try request.asURLRequest()
        } catch let e as NetworkError {
            throw e
        } catch {
            throw .unknown
        }
        
        let dr = await session.request(urlRequest)
            .validate(statusCode: 200..<300)
            .serializingData(emptyResponseCodes: [200, 300])
            .response
        
        if let afError = dr.error {
            throw mapAFError(afError, dr.response, dr.data)
        }
    }
    
    private func mapAFError(
        _ error: AFError,
        _ httpResponse: HTTPURLResponse?,
        _ data: Data?
    ) -> NetworkError {
        if let data = data,
           let apiError = try? decoder.decode(APIErrorResponse.self, from: data) {
            return mapAPIError(apiError)
        }
        
        if let status = httpResponse?.statusCode {
            switch status {
            case 200..<300: break
            case 401: return .unauthorized(message: nil)
            case 403: return .forbidden(message: nil)
            case 404: return .notFound(message: nil)
            case 500..<600: return .serverError(status, message: nil)
            default: return .invalidResponse
            }
        }
        
        if let underlying = error.underlyingError as? URLError {
            switch underlying.code {
            case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed:
                return .noInternetConnection
            case .timedOut,
                    .cannotFindHost, .cannotConnectToHost, .dnsLookupFailed:
                return .noInternetConnection
            default:
                return .noInternetConnection
            }
        }
        
        return .invalidResponse
    }
    
    private func mapAPIError(_ apiError: APIErrorResponse) -> NetworkError {
        let statusCode = apiError.data.statusCode
        let message = apiError.data.message
        
        switch statusCode {
        case 401:
            return .unauthorized(message: message)
        case 403:
            return .forbidden(message: message)
        case 404:
            return .notFound(message: message)
        case 500..<600:
            return .serverError(statusCode, message: message)
        default:
            return .invalidResponse
        }
    }
}
