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

@main
struct MeritusApp: App {
    init() {
        setupDependencies()
        setupUI()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RouteFactory().makeLogin()
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
            DomainDependencyInjection.self
        ]
        
        AppDependencies.setupAll(
            modules: modules
        )
    }
}

extension MeritusApp {
    private func setupUI() {
        ObsidianFont.registerFonts()
    }
}
