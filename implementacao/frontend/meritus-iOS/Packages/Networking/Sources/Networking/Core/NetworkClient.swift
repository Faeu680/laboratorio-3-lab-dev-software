//
//  NetworkClient.swift
//  Networking
//
//  Created by Arthur Porto on 17/10/25.
//

import Foundation
import Alamofire
import Session

final class NetworkClient: NetworkClientProtocol {
    private let AFSession: Session
    private let session: SessionProtocol
    private let decoder = JSONDecoder()
    
    init(
        AFSession: Session,
        session: SessionProtocol
    ) {
        self.AFSession = AFSession
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
            urlRequest = try await mapAPIRequest(request)
        } catch  {
            throw error
        }
        
        let dr = await AFSession.request(urlRequest)
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
            urlRequest = try await mapAPIRequest(request)
        } catch {
            throw error
        }
        
        let dr = await AFSession.request(urlRequest)
            .validate(statusCode: 200..<300)
            .serializingData(emptyResponseCodes: [200, 300])
            .response
        
        if let afError = dr.error {
            throw mapAFError(afError, dr.response, dr.data)
        }
    }
    
    private func mapAPIRequest(_ request: some APIRequest) async throws(NetworkError) -> URLRequest {
        let absolutePath = "https://meritus.bitpickle.dev/api"
        let completePath: String
        
        if !request.usePathAsURL {
            completePath = absolutePath + request.path
        } else {
            completePath = request.path
        }
        
        guard var urlComponents = URLComponents(string: completePath) else {
            throw .invalidURL
        }
        
        if let queryItems = request.queryItems {
            urlComponents.queryItems = queryItems
        }
        
        guard let url = urlComponents.url else {
            throw .invalidURL
        }
        
        var finalRequest = URLRequest(url: url)
        finalRequest.httpMethod = request.method.rawValue
        finalRequest.timeoutInterval = request.timeout
        
        var finalHeaders = request.headers ?? [:]
        
        if case .authenticated = request.scope {
            if let token = await session.getActiveToken() {
                finalHeaders["Authorization"] = "Bearer \(token)"
            }
        }
        
        finalHeaders.forEach { key, value in
            finalRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        switch request.body {
        case .none:
            break
        case let .json(encodable):
            do {
                let data = try JSONEncoder().encode(encodable)
                finalRequest.httpBody = data
                finalRequest.setValue(request.contentType.rawValue, forHTTPHeaderField: "Content-Type")
            } catch {
                throw .encodingError(error)
            }
        case let .data(data):
            finalRequest.httpBody = data
        }
        
        return finalRequest
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
