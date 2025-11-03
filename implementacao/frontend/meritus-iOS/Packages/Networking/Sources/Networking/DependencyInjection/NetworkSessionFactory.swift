//
//  NetworkSessionFactory.swift
//  Networking
//
//  Created by Arthur Porto on 02/11/25.
//

import Foundation
import Alamofire

enum NetworkSessionFactory {
    static func make(
        store: NetworkDebugStoreProtocol,
        configure: (URLSessionConfiguration) -> Void = { _ in }
    ) -> Session {
        let config = URLSessionConfiguration.af.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        configure(config)
        let logger = NetworkDebugLogger(store: store)
        return Session(configuration: config, eventMonitors: [logger])
    }
}
