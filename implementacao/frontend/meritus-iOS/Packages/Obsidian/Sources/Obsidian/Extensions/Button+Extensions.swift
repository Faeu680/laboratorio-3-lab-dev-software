//
//  Button+Extensions.swift
//  Obsidian
//
//  Created by Arthur Porto on 23/11/25.
//

import SwiftUI

public extension Button where Label == Text {
    init(
        _ titleKey: LocalizedStringKey,
        async action: @escaping @Sendable () async -> Void
    ) {
        self = Button(titleKey) {
            Task(priority: .userInitiated) { await action() }
        }
    }
    
    init(
        _ titleKey: LocalizedStringKey,
        async action: (@Sendable () async -> Void)?
    ) {
        self = Button(titleKey) {
            Task(priority: .userInitiated) { await action?() }
        }
    }

    init<S: StringProtocol>(
        _ title: S,
        async action: @escaping @Sendable () async -> Void
    ) {
        self = Button(String(title)) {
            Task(priority: .userInitiated) { await action() }
        }
    }
    
    init<S: StringProtocol>(
        _ title: S,
        async action: (@Sendable () async -> Void)?
    ) {
        self = Button(String(title)) {
            Task(priority: .userInitiated) { await action?() }
        }
    }
}

public extension Button {
    init(
        async action: @escaping @Sendable () async -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self = Button(action: {
            Task(priority: .userInitiated) { await action() }
        }, label: label)
    }
    
    init(
        async action: (@Sendable () async -> Void)?,
        @ViewBuilder label: () -> Label
    ) {
        self = Button(action: {
            Task(priority: .userInitiated) { await action?() }
        }, label: label)
    }
    
    init(
        role: ButtonRole? = nil,
        async action: @escaping @Sendable () async -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self = Button(role: role, action: {
            Task(priority: .userInitiated) { await action() }
        }, label: label)
    }
    
    init(
        role: ButtonRole? = nil,
        async action: (@Sendable () async -> Void)?,
        @ViewBuilder label: () -> Label
    ) {
        self = Button(role: role, action: {
            Task(priority: .userInitiated) { await action?() }
        }, label: label)
    }
}
