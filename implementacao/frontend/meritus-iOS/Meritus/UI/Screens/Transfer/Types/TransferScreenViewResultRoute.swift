//
//  TransferScreenViewResultRoute.swift
//  Meritus
//
//  Created by Arthur Porto on 25/11/25.
//

import Obsidian

enum TransferScreenViewResultRoute: Hashable {
    case success
    case error
    
    var feedbackViewStyle: ObsidianFeedbackView.Style {
        switch self {
        case .success:
            return .success
        case .error:
            return .error
        }
    }
}
