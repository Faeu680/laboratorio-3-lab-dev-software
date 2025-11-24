//
//  ResourceSelectScreenViewModelProtocol.swift
//  Meritus
//
//  Created by Arthur Porto on 18/11/25.
//

import Combine

@MainActor
protocol ResourceSelectScreenViewModelProtocol: ObservableObject {
    associatedtype Resource: ResourceSelectScreenViewProtocol
    
    var toolbarTitle: String { get }
    
    var selectedResource: Resource { get set }
    var availableResources: [Resource] { get }
    
    func select(_ resource: Resource)
}
