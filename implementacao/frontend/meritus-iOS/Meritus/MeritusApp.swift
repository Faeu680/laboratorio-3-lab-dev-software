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
                registers: [
                    resolver.resolveUnwrapping(AppRouteRegister.self, name: AppDependencyKey.RouteRegister.app.rawValue)
                ]
            ) {
                SplashScreenView()
            }
        }
    }
}

extension MeritusApp {
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
}

extension MeritusApp {
    private func setupUI() {
        ObsidianFont.registerFonts()
    }
}
