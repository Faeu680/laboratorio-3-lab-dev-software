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
            case .success:
                return "success_animation"
            case .error:
                return "error_animation"
            }
        }
        
        var color: Color {
            switch self {
            case .success:
                return .green
            case .error:
                return .red
            }
        }
    }
    
    private let style: Style
    private let title: String
    private let message: String?
    
    public init(
        _ style: Style,
        title: String,
        message: String? = nil
    ) {
        self.style = style
        self.title = title
        self.message = message
    }
    
    public var body: some View {
        VStack(spacing: .size24) {
            LottieView(
                animation: .named(style.animationName, bundle: .module)
            )
            .playbackMode(.playing(.fromProgress(0, toProgress: 1, loopMode: .loop)))
            .frame(width: 120, height: 120)
            
            Text(title)
                .font(.system(size: 24, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundStyle(style.color)
            
            if let message {
                Text(message)
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, .size16)
            }
        }
    }
}

#Preview {
    return ObsidianPreviewContainer {
        ObsidianFeedbackView(
            .success,
            title: "Teste"
        )
    }
}
