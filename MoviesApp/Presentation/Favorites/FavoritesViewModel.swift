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

    init(getFavorites: GetFavoritesUseCase, repo: MoviesRepository, toggleFavorite: ToggleFavoriteUseCase) {
        self.getFavorites = getFavorites
        self.repo = repo
        self.toggleFavorite = toggleFavorite
    }

    func refresh() async {
        isLoading = true
        defer {
            isLoading = false
        }
        let ids = getFavorites.execute()
        // first 20 parts upload in parallel
        items.removeAll()
        await withTaskGroup(of: Movie?.self) { group in
            for id in ids.prefix(20) {
                group.addTask {
                    let dto = try? await self.repo.details(id: id)
                    return dto?.toDomain().toMovie()
                }
            }
            for await m in group {
                if let m {
                    items.append(m)
                }
            }
        }
    }

    func onToggleFavorite(_ id: Int) {
        toggleFavorite.execute(id: id)
        Task {
            await refresh()
        }
    }
}
