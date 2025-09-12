//
//  LargePosterView.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 12.09.2025.
//

import SwiftUI

struct LargePosterView: View {
    let posterPath: String?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemBackground))

            if let path = posterPath,
               let url = URL(string: AppConfig.imagesBaseURL.absoluteString + path) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Color.gray.opacity(0.25)
                    @unknown default:
                        Color.gray.opacity(0.25)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
        }
        .aspectRatio(2/3, contentMode: .fit)
        .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)
    }
}
