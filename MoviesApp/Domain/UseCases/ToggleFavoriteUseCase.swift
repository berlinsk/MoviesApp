//
//  ToggleFavoriteUseCase.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import Foundation

struct ToggleFavoriteUseCase {
    let favorites: FavoritesRepository
    func execute(id: Int) {
        favorites.toggle(id: id)
    }
}
