//
//  BenefitCard.swift
//  Obsidian
//
//  Created by Arthur Porto on 03/11/25.
//

import SwiftUI

public struct BenefitCard: View {
    private let id: UUID
    private let title: String
    private let description: String
    private let price: Decimal
    private let image: Image

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
        self.image = image
    }

    public var body: some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.black.opacity(0.04))
            )
            .shadow(color: Color.black.opacity(0.35), radius: 18, x: 0, y: 10)
    }

    // MARK: - Content

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

    private var headerImage: some View {
        image
            .resizable()
            .frame(height: 180)
            .frame(maxWidth: .infinity)
            .scaledToFill()
            .clipped()
            .cornerRadius(.size24, corners: [.topLeft, .topRight])
    }

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
                BenefitCard(
                    title: "Spa Premium Experience",
                    description: "Dia completo de relaxamento em spa 5 estrelas com massagem e tratamento facial. Inclui acesso à sauna e piscina aquecida.",
                    price: 850,
                    image: Image("spa_header")
                )

                BenefitCard(
                    title: "Jantar Degustação Michelin",
                    description: "Menu degustação com harmonização em restaurante premiado.",
                    price: 1250,
                    image: Image("michelin_dinner")
                )
            }
            .padding(16)
        }
    }
}
