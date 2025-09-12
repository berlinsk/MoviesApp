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
                                        withAnimation(.easeInOut(duration: 0.35)) {
                                            vm.onToggleFavorite(m.id)
                                        }
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
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .scale(scale: 0.95)),
                                removal: .opacity.combined(with: .scale(scale: 0.8))
                            ))
                        }
                    }
                    .padding(16)
                    .animation(.easeInOut(duration: 0.35), value: vm.items.count)

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
    }
}
