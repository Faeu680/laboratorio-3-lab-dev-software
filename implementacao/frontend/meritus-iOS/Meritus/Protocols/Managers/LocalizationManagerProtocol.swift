//
//  LocalizationManagerProtocol.swift
//  Meritus
//
//  Created by Arthur Porto on 18/11/25.
//

import Foundation
import Combine

@MainActor
protocol LocalizationManagerProtocol: ObservableObject {
    func setLocale(_ locale: Locale)
}
