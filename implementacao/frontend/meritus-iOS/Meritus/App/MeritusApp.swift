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
import Commons
#if DEBUG
import TestMode
#endif

@main
struct MeritusApp: App {
    private let appDependencies = AppDependencies.self
    
    @StateObject private var localizationManager = LocalizationManager.shared
    @StateObject private var colorSchemeManager = ColorSchemeManager.shared
    
    #if DEBUG
    @State private var showRequests = false
    #endif
    
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
            .environmentObject(localizationManager)
            .environmentObject(colorSchemeManager)
            .environment(\.locale, localizationManager.language.locale)
            .preferredColorScheme(colorSchemeManager.scheme.colorScheme)
            #if DEBUG
            .simultaneousGesture(
                TapGesture(count: 5)
                    .onEnded { showRequests = true }
            )
            .sheet(isPresented: $showRequests) {
                makeDebugScreenView()
                    .presentationDetents([.large, .large])
            }
            #endif
        }
    }
    
    private func setupDependencies() {
        let modules: [any DependencyModule.Type] = [
            NetworkingDependencyInjection.self,
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
        let viewModel = SplashScreenViewModel(bootsrapUseCase: bootsrapUseCase)
        return SplashScreenView(viewModel: viewModel)
    }
    
    private func makeDebugScreenView() -> some View {
        let store = resolver.resolveUnwrapping(NetworkDebugStoreProtocol.self)
        let viewModel = NetworkDebugScreenViewModel(store: store)
        return NetworkDebugScreenView(viewModel: viewModel)
    }
    
    private func setupUI() {
        ObsidianSetup.setup()
    }
}
