//
//  FavoritesRepository.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import Foundation

protocol FavoritesRepository {
    func toggle(id: Int)
    func isFavorite(id: Int) -> Bool
    func allIDs() -> [Int]
}

final class UserDefaultsFavoritesRepository: FavoritesRepository {
    private let key = "favorites_ids"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func toggle(id: Int) {
        var set = Set(allIDs())
        if set.contains(id) {
            set.remove(id)
        } else {
            set.insert(id)
        }
        defaults.set(Array(set), forKey: key)
    }

    func isFavorite(id: Int) -> Bool {
        Set(allIDs()).contains(id)
    }

    func allIDs() -> [Int] {
        (defaults.array(forKey: key) as? [Int]) ?? []
    }
}
