//
//  FavoritesViewModel.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import Foundation

@MainActor
final class FavoritesViewModel: ObservableObject {
    private let getFavorites: GetFavoritesUseCase
    private let repo: MoviesRepository
    private let toggleFavorite: ToggleFavoriteUseCase

    @Published private(set) var items: [Movie] = []
    @Published var isLoading = false
    
    /* Favorites pagination works differently than Top Rated:
     - TMDB API does'nt provide paging for a user-defined list of IDs
     - therefore, I simulate "paging" by slicing the local ID list(first 20)
     - each slice is fetched in parallel (withTaskGroup) to speed up network calls
     - this is more efficient than sequential requests, and acceptable since favorites are usually a relatively small set compared to Top Rated movies
    */
    private var favIDs: [Int] = []
    private var nextIndex: Int = 0
    private let chunkSize: Int = 20

    init(getFavorites: GetFavoritesUseCase, repo: MoviesRepository, toggleFavorite: ToggleFavoriteUseCase) {
        self.getFavorites = getFavorites
        self.repo = repo
        self.toggleFavorite = toggleFavorite
    }
    
    func reload() async {
        isLoading = true
        favIDs = getFavorites.execute()
        nextIndex = 0
        items = []
        isLoading = false
        await loadMore()
    }
    
    func loadMore() async {
        guard !isLoading else {
            return
        }
        guard nextIndex < favIDs.count else {
            return
        }

        isLoading = true
        defer {
            isLoading = false
        }

        let start = nextIndex
        let end = min(start + chunkSize, favIDs.count)
        let slice = Array(favIDs[start..<end])
        nextIndex = end

        var batch: [(pos: Int, movie: Movie)] = []
        await withTaskGroup(of: (Int, Movie?)?.self) { group in
            for (offset, id) in slice.enumerated() {
                let absolutePos = start + offset
                group.addTask { [repo] in
                    let dto = try? await repo.details(id: id)
                    return (absolutePos, dto?.toDomain().toMovie())
                }
            }
            for await result in group {
                if let (pos, maybeMovie) = result, let m = maybeMovie {
                    batch.append((pos: pos, movie: m))
                }
            }
        }

        batch.sort { $0.pos < $1.pos }

        items.append(contentsOf: batch.map { $0.movie })
    }

    func onToggleFavorite(_ id: Int) {
        toggleFavorite.execute(id: id)
        if let idx = items.firstIndex(where: { $0.id == id }) {
            items.remove(at: idx)
        }
        favIDs.removeAll { $0 == id }
    }
}
