//
//  BenefitCard.swift
//  Obsidian
//
//  Created by Arthur Porto on 03/11/25.
//

import SwiftUI
private import Kingfisher

public struct BenefitCard: View {
    
    private enum ImageSource {
        case local(Image)
        case remote(String)
    }
    
    private let id: UUID
    private let title: String
    private let description: String
    private let price: String
    private let headerSource: ImageSource
    private var action: (@Sendable () async -> Void)?

    // MARK: - Inits

    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        price: String,
        imageURL: String?,
        onTap action: (@Sendable () async -> Void)? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.price = price
        if let imageURL {
            self.headerSource = .remote(imageURL)
        } else {
            self.headerSource = .remote("")
        }
        self.action = action
    }

    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        price: String,
        image: Image,
        onTap action: (@Sendable () async -> Void)? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.price = price
        self.headerSource = .local(image)
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 0) {
            headerImage
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .obsidianBody()
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                
                Text(description)
                    .obsidianBody()
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                
                pricePill
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.all, .size16)
        }
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.black.opacity(0.04))
        )
        .shadow(color: Color.black.opacity(0.35), radius: 18, x: 0, y: 10)
        .if(action != nil) { view in
            Button(async: action) {
                view
            }
            .buttonStyle(.plain)
        }
    }

    private var headerImage: some View {
        Group {
            switch headerSource {
            case .local(let image):
                image
                    .resizable()
                    .scaledToFill()

            case .remote(let urlString):
                if let url = URL(string: urlString) {
                    KFImage(url)
                        .placeholder {
                            Rectangle().fill(Color.gray.opacity(0.2))
                        }
                        .resizable()
                        .scaledToFill()
                } else {
                    Rectangle().fill(Color.gray.opacity(0.2))
                }
            }
        }
        .frame(height: 180)
        .frame(maxWidth: .infinity)
        .clipped()
        .cornerRadius(.size24, corners: [.topLeft, .topRight])
    }

    // MARK: - Price Pill

    private var pricePill: some View {
        Text("MC \(price)")
            .font(.obsidianButton)
            .foregroundStyle(.primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.black.opacity(0.6))
            )
            .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 6)
    }
}

// MARK: - Builders

public extension BenefitCard {
    func onTap(action: (@Sendable () async -> Void)?) -> Self {
        then{ $0.action = action }
    }
}
