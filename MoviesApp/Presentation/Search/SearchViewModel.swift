//
//  SearchViewModel.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var query = ""
    @Published private(set) var results: [Movie] = []
    @Published var isLoading = false
    @Published var errorText: String?

    private let searchMovies: SearchMoviesUseCase
    private let favorites: FavoritesRepository
    private let toggleFavorite: ToggleFavoriteUseCase

    private var cancellables = Set<AnyCancellable>()
    private var page = 1
    private var totalPages = 1

    init(searchMovies: SearchMoviesUseCase,
         favorites: FavoritesRepository,
         toggleFavorite: ToggleFavoriteUseCase) {
        self.searchMovies = searchMovies
        self.favorites = favorites
        self.toggleFavorite = toggleFavorite

        $query
            .removeDuplicates()
            .debounce(for: .milliseconds(350), scheduler: RunLoop.main)
            .sink { [weak self] text in
                Task {
                    await self?.performSearch(text: text)
                }
            }
            .store(in: &cancellables)
    }

    func isFavorite(_ id: Int) -> Bool {
        favorites.isFavorite(id: id)
    }
    func onToggleFavorite(_ id: Int) {
        toggleFavorite.execute(id: id)
        objectWillChange.send()
    }

    func loadMoreIfNeeded(item: Movie) async {
        guard item.id == results.suffix(4).first?.id, page < totalPages, !isLoading else {
            return
        }
        page += 1
        await search(page: page)
    }

    private func performSearch(text: String) async {
        guard text.count >= 3 else {
            results = []
            return
        }
        page = 1
        totalPages = 1
        results = []
        await search(page: page)
    }

    private func search(page: Int) async {
        isLoading = true
        defer {
            isLoading = false
        }
        do {
            let r = try await searchMovies.execute(query: query, page: page)
            totalPages = r.totalPages
            results.append(contentsOf: r.movies)
        } catch {
            errorText = String(describing: error)
        }
    }
}
