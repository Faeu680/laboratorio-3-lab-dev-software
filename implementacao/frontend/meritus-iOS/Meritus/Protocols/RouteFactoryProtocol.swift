//
//  RouteFactoryProtocol.swift
//  Meritus
//
//  Created by Arthur Porto on 31/10/25.
//

protocol RouteFactoryProtocol {
    @MainActor
    func makeLogin() -> LoginScreenView
    
    @MainActor
    func makeHome() -> HomeScreenView
}
