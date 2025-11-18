//
//  BenefitCard.swift
//  Obsidian
//
//  Created by Arthur Porto on 03/11/25.
//

import SwiftUI
import Kingfisher

public struct BenefitCard: View {
    
    private enum ImageSource {
        case local(Image)
        case remote(String)
    }
    
    private let id: UUID
    private let title: String
    private let description: String
    private let price: Decimal
    private let headerSource: ImageSource

    // MARK: - Inits

    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        price: Decimal,
        imageURL: String?
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
    }

    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        price: Decimal,
        image: Image
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.price = price
        self.headerSource = .local(image)
    }

    // MARK: - Body

    public var body: some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.black.opacity(0.04))
            )
            .shadow(color: Color.black.opacity(0.35), radius: 18, x: 0, y: 10)
    }

    private var content: some View {
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
    }

    // MARK: - Header Image

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

// MARK: - Preview

#Preview("BenefitCard") {
    ObsidianPreviewContainer {
        ScrollView {
            VStack(spacing: 24) {

                // Usando imagem remota
                BenefitCard(
                    title: "Spa Premium Experience",
                    description: "Dia completo de relaxamento em spa 5 estrelas.",
                    price: 850,
                    imageURL: "https://picsum.photos/600"
                )

                // Usando imagem local
                BenefitCard(
                    title: "Jantar Michelin",
                    description: "Menu degustação harmonizado.",
                    price: 1250,
                    image: Image("michelin_dinner")
                )
            }
            .padding(16)
        }
    }
}
