//
//  TopRatedViewModel.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import Foundation

@MainActor
final class TopRatedViewModel: ObservableObject {
    private let getTopRated: GetTopRatedMoviesUseCase
    private let toggleFavorite: ToggleFavoriteUseCase
    private let favorites: FavoritesRepository

    @Published private(set) var movies: [Movie] = []
    @Published var isLoading = false
    @Published var totalPages = 1
    @Published var currentPage = 0
    @Published var errorText: String?

    var averageText: String {
        let avg = movies.map(\.voteAverage).average
        return String(format: "Avg: %.1f", avg)
    }

    init(getTopRated: GetTopRatedMoviesUseCase,
         toggleFavorite: ToggleFavoriteUseCase,
         favorites: FavoritesRepository) {
        self.getTopRated = getTopRated
        self.toggleFavorite = toggleFavorite
        self.favorites = favorites
    }

    func refresh() async {
        currentPage = 0
        movies.removeAll()
        await loadNextBatchIfNeeded(force: true)
    }

    func isFavorite(_ id: Int) -> Bool { favorites.isFavorite(id: id) }

    func onToggleFavorite(_ id: Int) {
        toggleFavorite.execute(id: id)
        objectWillChange.send()
    }

    // pagination: two pages in parallel
    func loadNextBatchIfNeeded(force: Bool = false, item: Movie? = nil) async {
        guard !isLoading else { return }
        if !force {
            guard let item = item, let last = movies.suffix(4).first else { return }
            guard item.id == last.id else { return }
        }
        guard currentPage < totalPages else { return }

        isLoading = true
        defer {
            isLoading = false
        }

        let next = currentPage + 1
        let second = min(next + 1, totalPages)

        do {
            async let a = getTopRated.execute(page: max(next, 1))
            async let b = (second > next) ? getTopRated.execute(page: second) : (([], totalPages) as (movies:[Movie], totalPages:Int))

            let r1 = try await a
            let r2 = try await b
            totalPages = max(r1.totalPages, r2.totalPages)

            let merged = (r1.movies + r2.movies)
            let unique = Array(Dictionary(grouping: merged, by: \.id).compactMap { $0.value.first })
                .sorted { $0.id < $1.id }

            movies.append(contentsOf: unique.filter { m in
                !movies.contains(where: { $0.id == m.id })
            })
            currentPage = second
        } catch {
            errorText = String(describing: error)
        }
    }
}
