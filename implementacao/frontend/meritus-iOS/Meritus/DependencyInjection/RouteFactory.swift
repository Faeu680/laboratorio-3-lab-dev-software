//
//  RouteFactory.swift
//  Meritus
//
//  Created by Arthur Porto on 17/10/25.
//

import DependencyInjection
import Domain

@MainActor
final class RouteFactory {
    
    private let resolver = AppDependencies.resolver
    
    func makeLogin() -> LoginScreenView {
        let signInUseCase = resolver.resolveUnwrapping(SignInUseCaseProtocol.self)
        let viewModel = LoginScreenViewModel(signInUseCase: signInUseCase)
        let view = LoginScreenView(viewModel: viewModel)
        return view
    }
    
    func makeHome() -> HomeScreenView {
        let viewModel = HomeScreenViewModel()
        let view = HomeScreenView(viewModel: viewModel)
        return view
    }
}
