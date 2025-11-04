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
        ZStack(alignment: .topLeading) {
            background
            content
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.35), radius: 18, x: 0, y: 10)
    }

    // MARK: - Background

    private var background: some View {
        RoundedRectangle(cornerRadius: 24, style: .continuous)
            .fill(Color.black.opacity(0.04))
    }

    // MARK: - Content

    private var content: some View {
        VStack(spacing: 0) {
            headerImage
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .obsidianBody()
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(description)
                        .obsidianBody()
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                }

                pricePill
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
    }

    private var headerImage: some View {
        image
            .resizable()
            .scaledToFill()
            .frame(height: 180)
            .frame(maxWidth: .infinity)
            .clipped()
            .overlay(
                Rectangle()
                    .fill(LinearGradient(
                        colors: [Color.black.opacity(0.0), Color.black.opacity(0.15)],
                        startPoint: .top,
                        endPoint: .bottom
                    ))
            )
            .mask(
                RoundedCornersMask(radius: 24, corners: [.topLeft, .topRight])
            )
    }

    private var pricePill: some View {
        Text("RS 200")
            .font(.obsidianButton)
            .foregroundStyle(.primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.black.opacity(0.6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 6)
    }
}

private struct RoundedCornersMask: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
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
