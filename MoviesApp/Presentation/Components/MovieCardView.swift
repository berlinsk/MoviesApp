//
//  MovieCardView.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import SwiftUI

struct MovieCardView: View {
    let title: String
    let rating: Double
    let posterPath: String?
    let isFavorite: Bool
    let onToggleFavorite: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack(alignment: .topTrailing) {
                poster
                    .frame(height: 240)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                Button(action: onToggleFavorite) {
                    Image(isFavorite ? "StarFull" : "StarEmpty")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .padding(8)
                }
                .buttonStyle(.borderless)
            }
            
            Text(title)
                .font(.headline)
                .lineLimit(2)
            
            Text(String(format: "Rating: %.1f", rating))
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }

    private var poster: some View {
        Group {
            if let path = posterPath,
               let url = URL(string: AppConfig.imagesBaseURL.absoluteString + path) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .failure:
                        Color.gray.opacity(0.2)
                    @unknown default:
                        Color.gray.opacity(0.2)
                    }
                }
            } else {
                Color.gray.opacity(0.2)
            }
        }
    }
}
