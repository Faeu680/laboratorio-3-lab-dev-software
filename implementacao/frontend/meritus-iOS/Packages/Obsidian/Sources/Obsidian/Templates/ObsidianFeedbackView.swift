//
//  ObsidianFeedbackView.swift
//  Obsidian
//
//  Created by Arthur Porto on 25/11/25.
//

import SwiftUI
private import Lottie

public struct ObsidianFeedbackView: View {
    public enum Style {
        case success
        case error

        var animationName: String {
            switch self {
            case .success: return "success_animation"
            case .error: return "error_animation"
            }
        }

        var color: Color {
            switch self {
            case .success: return .green
            case .error: return .red
            }
        }
    }

    private let style: Style
    private let onAnimationFinished: (() -> Void)?

    public init(
        _ style: Style,
        onAnimationFinished: (() -> Void)? = nil
    ) {
        self.style = style
        self.onAnimationFinished = onAnimationFinished
    }

    public var body: some View {
        VStack(spacing: .size24) {
            LottieView(
                animation: .named(style.animationName, bundle: .module),
            )
            .playbackMode(.playing(.fromProgress(0, toProgress: 1, loopMode: .playOnce)))
            .animationDidFinish { _ in
                onAnimationFinished?()
            }
            .frame(width: 120, height: 120)
        }
        .navigationBarBackButtonHidden()
    }
}
