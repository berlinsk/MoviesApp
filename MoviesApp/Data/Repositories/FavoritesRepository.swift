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
