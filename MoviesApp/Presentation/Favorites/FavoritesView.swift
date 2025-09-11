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
            ScrollView {
                if vm.items.isEmpty && vm.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(vm.items, id: \.id) { m in
                            NavigationLink(
                                destination: MovieDetailsView(
                                    vm: ViewModelFactory.movieDetailsVM(id: m.id)
                                )
                            ) {
                                MovieCardView(
                                    title: m.title,
                                    rating: m.voteAverage,
                                    posterPath: m.posterPath,
                                    isFavorite: true,
                                    onToggleFavorite: {
                                        vm.onToggleFavorite(m.id)
                                    }
                                )
                                .frame(height: 300)
                            }
                            .buttonStyle(.plain)
                            .onAppear {
                                if m.id == vm.items.last?.id {
                                    Task {
                                        await vm.loadMore()
                                    }
                                }
                            }
                        }
                    }
                    .padding(16)

                    if vm.isLoading {
                        ProgressView().padding(.vertical, 16)
                    }
                }
            }
            .navigationTitle("Favorites")
            .task {
                await vm.reload()
            }
        }
        .navigationViewStyle(.stack)
        .transaction {
            $0.disablesAnimations = true
        }
    }
}
