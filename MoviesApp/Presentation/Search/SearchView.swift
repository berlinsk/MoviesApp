//
//  SearchView.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import SwiftUI

struct SearchView: View {
    @StateObject var vm: SearchViewModel

    private let columns = [GridItem(.flexible(), spacing: 12),
                           GridItem(.flexible(), spacing: 12)]

    init(vm: SearchViewModel?) {
        // NavigationLink without DI leakage (AI helped me to cope with it)
        _vm = StateObject(wrappedValue: vm ?? SearchViewModel(
            searchMovies: SearchMoviesUseCase(repo: DefaultMoviesRepository(client: NetworkClient())),
            favorites: UserDefaultsFavoritesRepository(),
            toggleFavorite: ToggleFavoriteUseCase(favorites: UserDefaultsFavoritesRepository())
        ))
    }

    var body: some View {
        VStack {
            TextField("Search...", text: $vm.query)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 16)
                .padding(.top, 8)

            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(vm.results, id: \.id) { m in
                        NavigationLink(
                            destination: MovieDetailsView(
                                vm: ViewModelFactory.movieDetailsVM(id: m.id)
                            )
                        ) {
                            MovieCardView(
                                title: m.title,
                                rating: m.voteAverage,
                                posterPath: m.posterPath,
                                isFavorite: vm.isFavorite(m.id),
                                onToggleFavorite: {
                                    vm.onToggleFavorite(m.id)
                                }
                            )
                        }
                        .buttonStyle(.plain)
                        .onAppear {
                            Task {
                                await vm.loadMoreIfNeeded(item: m)
                            }
                        }
                    }
                }
                .padding(16)
                if vm.isLoading {
                    DotsLoader()
                        .frame(width: 80, height: 80)
                        .padding()
                }
            }
        }
        .navigationTitle("Search")
        .alert("Error", isPresented: .constant(vm.errorText != nil), actions: {
            Button("OK") {
                vm.errorText = nil
            }
        }, message: {
            Text(vm.errorText ?? "")
        })
    }
}
