//
//  GetFavoritesUseCase.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import Foundation

struct GetFavoritesUseCase {
    let favorites: FavoritesRepository
    func execute() -> [Int] {
        favorites.allIDs()
    }
}
