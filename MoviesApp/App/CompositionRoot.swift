//
//  AppDI.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import Foundation

@MainActor
final class AppContainer {
    static let shared = AppContainer()
    
    let client = NetworkClient()
    lazy var moviesRepo: MoviesRepository = DefaultMoviesRepository(client: client)
    let favoritesRepo: FavoritesRepository = UserDefaultsFavoritesRepository()
    
    private init() {}
}

@MainActor
enum ViewModelFactory {
    private static let c = AppContainer.shared

    //share between screens (the state is saved between tabs)
    static let topRatedVM: TopRatedViewModel = TopRatedViewModel(
        getTopRated: GetTopRatedMoviesUseCase(repo: c.moviesRepo),
        toggleFavorite: ToggleFavoriteUseCase(favorites: c.favoritesRepo),
        favorites: c.favoritesRepo
    )

    static let searchVM: SearchViewModel = SearchViewModel(
        searchMovies: SearchMoviesUseCase(repo: c.moviesRepo),
        favorites: c.favoritesRepo,
        toggleFavorite: ToggleFavoriteUseCase(favorites: c.favoritesRepo)
    )

    static let favoritesVM: FavoritesViewModel = FavoritesViewModel(
        getFavorites: GetFavoritesUseCase(favorites: c.favoritesRepo),
        repo: c.moviesRepo,
        toggleFavorite: ToggleFavoriteUseCase(favorites: c.favoritesRepo)
    )

    // create a new instance for each transition
    static func movieDetailsVM(id: Int) -> MovieDetailsViewModel {
        MovieDetailsViewModel(
            id: id,
            getDetails: GetMovieDetailsUseCase(repo: c.moviesRepo),
            toggleFavorite: ToggleFavoriteUseCase(favorites: c.favoritesRepo),
            favorites: c.favoritesRepo
        )
    }
}
