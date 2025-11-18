//
//  ResourceSelectScreenViewModelProtocol.swift
//  Meritus
//
//  Created by Arthur Porto on 18/11/25.
//

import Combine

protocol ResourceType: Hashable, Equatable {
    var title: String { get }
}

@MainActor
protocol ResourceSelectScreenViewModelProtocol: ObservableObject {
    associatedtype Resource: ResourceType
    
    var toolbarTitle: String { get }
    
    var selectedResource: Resource { get set }
    var availableResources: [Resource] { get }
    
    func select(_ resource: Resource)
}
