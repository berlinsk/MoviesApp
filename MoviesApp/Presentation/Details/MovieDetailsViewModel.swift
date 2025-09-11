//
//  MovieDetailsViewModel.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import Foundation

@MainActor
final class MovieDetailsViewModel: ObservableObject {
    private let getDetails: GetMovieDetailsUseCase
    private let toggleFavorite: ToggleFavoriteUseCase
    private let favorites: FavoritesRepository

    @Published var details: MovieDetails?
    @Published var isLoading = false
    @Published var errorText: String?

    let id: Int

    init(id: Int,
         getDetails: GetMovieDetailsUseCase,
         toggleFavorite: ToggleFavoriteUseCase,
         favorites: FavoritesRepository) {
        self.id = id
        self.getDetails = getDetails
        self.toggleFavorite = toggleFavorite
        self.favorites = favorites
    }

    func load() async {
        isLoading = true
        defer {
            isLoading = false
        }
        do {
            details = try await getDetails.execute(id: id)
        } catch {
            errorText = String(describing: error)
        }
    }

    var isFavorite: Bool {
        favorites.isFavorite(id: id)
    }
    func onToggleFavorite() {
        toggleFavorite.execute(id: id)
        objectWillChange.send()
    }
}
