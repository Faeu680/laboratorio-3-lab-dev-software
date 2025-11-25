//
//  ResourceSelectScreenViewModelProtocol.swift
//  Meritus
//
//  Created by Arthur Porto on 18/11/25.
//

import Combine
import Commons

@MainActor
protocol ResourceSelectScreenViewModelProtocol: ObservableObject, Sendable {
    associatedtype Resource: Hashable & Sendable
    
    var toolbarTitle: String { get }
    
    var selectedResource: Resource { get }
    var availableResources: [Resource] { get }
    
    func select(_ resource: Resource)
}
