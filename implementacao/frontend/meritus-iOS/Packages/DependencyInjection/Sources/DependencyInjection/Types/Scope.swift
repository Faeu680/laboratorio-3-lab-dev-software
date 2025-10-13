//
//  Scope.swift
//  DependencyInjection
//
//  Created by Arthur Porto on 13/10/25.
//

public enum Scope: Sendable {
    case transient
    case singleton
    case weakSingleton
}
