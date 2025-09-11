//
//  PageDTO.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import Foundation

struct PageDTO<T: Decodable>: Decodable {
    let page: Int
    let results: [T]
    let totalPages: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
    }
}
