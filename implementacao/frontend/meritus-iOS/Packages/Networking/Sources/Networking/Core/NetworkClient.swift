//
//  NetworkClient.swift
//  Networking
//
//  Created by Arthur Porto on 17/10/25.
//

import Foundation
import Alamofire

final class NetworkClient: NetworkClientProtocol {
    private let session: Session = .default
    private let decoder: JSONDecoder = .init()

    func request<T: Decodable>(_ request: some Request) async throws(NetworkError) -> NetworkResponse<T> {
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
            throw mapAFError(afError, dr.response)
        }

        guard let value = dr.value else {
            throw .invalidResponse
        }
        return value
    }

    func request(_ request: some Request) async throws(NetworkError) {
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
            .serializingData()
            .response

        if let afError = dr.error {
            throw mapAFError(afError, dr.response)
        }
    }

    private func mapAFError(_ error: AFError, _ httpResponse: HTTPURLResponse?) -> NetworkError {
        if let status = httpResponse?.statusCode {
            switch status {
            case 200..<300: break
            case 401: return .unauthorized
            case 403: return .forbidden
            case 404: return .notFound
            case 500..<600: return .serverError(status)
            default: return .invalidResponse
            }
        }

        if let underlying = error.underlyingError as? URLError {
            switch underlying.code {
            case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed:
                return .noInternetConnection
            case .timedOut,
                 .cannotFindHost, .cannotConnectToHost, .dnsLookupFailed:
                return .networkError(underlying)
            default:
                return .networkError(underlying)
            }
        }

        return .networkError(error)
    }
}
