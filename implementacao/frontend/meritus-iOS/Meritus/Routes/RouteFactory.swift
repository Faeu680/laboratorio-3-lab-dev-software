//
//  RouteFactory.swift
//  Meritus
//
//  Created by Arthur Porto on 17/10/25.
//

import DependencyInjection
import Domain

final class RouteFactory: RouteFactoryProtocol {
    
    private let resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }
    
    @MainActor
    func makeLogin() -> LoginScreenView {
        let signInUseCase = resolver.resolveUnwrapping(SignInUseCaseProtocol.self)
        let viewModel = LoginScreenViewModel(signInUseCase: signInUseCase)
        let view = LoginScreenView(viewModel: viewModel)
        return view
    }
    
    @MainActor
    func makeSignUp() -> SignUpScreenView {
        let studentSignUpUseCase = resolver.resolveUnwrapping(SignUpStudentUseCaseProtocol.self)
        let viewModel = SignUpScreenViewModel(studentSignUpUseCase: studentSignUpUseCase)
        let view = SignUpScreenView(viewModel: viewModel)
        return view
    }
    
    @MainActor
    func makeHome() -> HomeScreenView {
        let viewModel = HomeScreenViewModel()
        let view = HomeScreenView(viewModel: viewModel)
        return view
    }
}
