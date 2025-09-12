//
//  FavoriteButton.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 12.09.2025.
//

import SwiftUI

struct FavoriteButton: View {
    let isFavorite: Bool
    let addTitle: String
    let removeTitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(isFavorite ? removeTitle : addTitle)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
        }
        .buttonStyle(.plain)
        .background(
            Group {
                if isFavorite {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(Color.primary, lineWidth: 2)
                } else {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(Color.favorite)
                }
            }
        )
        .foregroundColor(isFavorite ? Color.primary : .black)
        .contentShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
    }
}
