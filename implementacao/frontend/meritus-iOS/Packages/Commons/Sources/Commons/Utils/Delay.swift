//
//  Delay.swift
//  Commons
//
//  Created by Arthur Porto on 25/11/25.
//

public func delay(
    _ seconds: Double,
    _ action: @escaping @Sendable () -> Void
) {
    Task {
        try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
        action()
    }
}

@MainActor
public func delayOnMain(
    _ seconds: Double,
    _ action: @escaping @Sendable () async -> Void
) {
    Task { @MainActor in
        try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
        await action()
    }
}
