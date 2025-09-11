//
//  FavoritesView.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject var vm: FavoritesViewModel
    private let columns = [GridItem(.flexible(), spacing: 12),
                           GridItem(.flexible(), spacing: 12)]

    var body: some View {
        NavigationView {
            Group {
                if vm.items.isEmpty && vm.isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(vm.items, id: \.id) { m in
                                MovieCardView(
                                    title: m.title,
                                    rating: m.voteAverage,
                                    posterPath: m.posterPath,
                                    isFavorite: true,
                                    onToggleFavorite: {
                                        vm.onToggleFavorite(m.id)
                                    }
                                )
                            }
                        }
                        .padding(16)
                    }
                }
            }
            .navigationTitle("Favorites")
            .task {
                await vm.refresh()
            }
        }
        .navigationViewStyle(.stack)
    }
}
