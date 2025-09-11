//
//  AppDI.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import Foundation

@MainActor
final class CompositionRoot {
    let client = NetworkClient()
    lazy var moviesRepo: MoviesRepository = DefaultMoviesRepository(client: client)
    let favoritesRepo: FavoritesRepository = UserDefaultsFavoritesRepository()

    lazy var topRatedVM = TopRatedViewModel(
        getTopRated: GetTopRatedMoviesUseCase(repo: moviesRepo),
        toggleFavorite: ToggleFavoriteUseCase(favorites: favoritesRepo),
        favorites: favoritesRepo
    )

    lazy var searchVM = SearchViewModel(
        searchMovies: SearchMoviesUseCase(repo: moviesRepo),
        favorites: favoritesRepo,
        toggleFavorite: ToggleFavoriteUseCase(favorites: favoritesRepo)
    )

    lazy var favoritesVM = FavoritesViewModel(
        getFavorites: GetFavoritesUseCase(favorites: favoritesRepo),
        repo: moviesRepo,
        toggleFavorite: ToggleFavoriteUseCase(favorites: favoritesRepo)
    )
}
