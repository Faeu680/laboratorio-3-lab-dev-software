//
//  MeritusApp.swift
//  Meritus
//
//  Created by Arthur Porto on 13/10/25.
//

import SwiftUI
import DependencyInjection
import Obsidian
import Networking
import Session
import Services
import Domain
import Navigation

@main
struct MeritusApp: App {
    private let appDependencies = AppDependencies.self
    
    private var resolver: Resolver {
        appDependencies.resolver
    }
    
    init() {
        setupDependencies()
        setupUI()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationContainer(
                registers: makeRegisters()
            ) {
                makeInitialScreen()
            }
        }
    }
    
    private func setupDependencies() {
        let modules: [any DependencyModule.Type] = [
            NetworkingDependencyModule.self,
            SessionDependencyInjection.self,
            ServicesDependencyInjection.self,
            DomainDependencyInjection.self,
            AppDependencyInjection.self
        ]
        
        appDependencies.setupAll(
            modules: modules
        )
    }
    
    private func makeRegisters() -> [some RouteRegisterProtocol] {
        [
            resolver.resolveUnwrapping(AppRouteRegister.self)
        ]
    }
    
    private func makeInitialScreen() -> some View {
        let bootsrapUseCase = resolver.resolveUnwrapping(BootstrapSessionUseCaseProtocol.self)
        let viewModel = SplashScreenViewModel(
            bootsrapUseCase: bootsrapUseCase
        )
        
        return SplashScreenView(viewModel: viewModel)
    }
    
    private func setupUI() {
        ObsidianSetup.setup()
    }
}
