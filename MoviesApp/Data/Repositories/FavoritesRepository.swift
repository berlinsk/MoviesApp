//
//  FavoritesRepository.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import Foundation
import Combine

protocol FavoritesRepository: AnyObject {
    var idsPublisher: Published<[Int]>.Publisher { get }
    func toggle(id: Int)
    func isFavorite(id: Int) -> Bool
    func allIDs() -> [Int]
}

final class UserDefaultsFavoritesRepository: FavoritesRepository, ObservableObject {
    private let key = "favorites_ids"
    private let defaults: UserDefaults

    @Published private var ids: [Int] = []
    var idsPublisher: Published<[Int]>.Publisher { $ids }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.ids = (defaults.array(forKey: key) as? [Int]) ?? []
    }

    func toggle(id: Int) {
        if ids.contains(id) {
            ids.removeAll { $0 == id }
        } else {
            ids.append(id)
        }
        defaults.set(ids, forKey: key)
    }

    func isFavorite(id: Int) -> Bool {
        ids.contains(id)
    }
    func allIDs() -> [Int] {
        ids
    }
}
