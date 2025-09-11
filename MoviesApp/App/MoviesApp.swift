//
//  MoviesAppApp.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import SwiftUI

@main
struct MoviesApp: App {
    @StateObject private var theme = ThemeManager()

    private static let client = NetworkClient()
    private static let moviesRepo: MoviesRepository = DefaultMoviesRepository(client: client)
    private static let favoritesRepo: FavoritesRepository = UserDefaultsFavoritesRepository()

    var body: some Scene {
        WindowGroup {
            RootView(
                topRatedVM: TopRatedViewModel(
                    getTopRated: GetTopRatedMoviesUseCase(repo: MoviesApp.moviesRepo),
                    toggleFavorite: ToggleFavoriteUseCase(favorites: MoviesApp.favoritesRepo),
                    favorites: MoviesApp.favoritesRepo
                ),
                searchVM: SearchViewModel(
                    searchMovies: SearchMoviesUseCase(repo: MoviesApp.moviesRepo),
                    favorites: MoviesApp.favoritesRepo,
                    toggleFavorite: ToggleFavoriteUseCase(favorites: MoviesApp.favoritesRepo)
                ),
                favoritesVM: FavoritesViewModel(
                    getFavorites: GetFavoritesUseCase(favorites: MoviesApp.favoritesRepo),
                    repo: MoviesApp.moviesRepo,
                    toggleFavorite: ToggleFavoriteUseCase(favorites: MoviesApp.favoritesRepo)
                )
            )
            .environmentObject(theme)
            .preferredColorScheme(theme.selected.colorScheme)
        }
    }
}
