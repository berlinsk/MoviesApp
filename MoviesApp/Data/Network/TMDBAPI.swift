//
//  TMDBAPI.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import Foundation

enum TMDBAPI {
    case topRated(page: Int)
    case movieDetails(id: Int)
    case search(query: String, page: Int)
    case similar(id: Int, page: Int)

    var path: String {
        switch self {
        case .topRated:
            return "/movie/top_rated"
        case .movieDetails(let id):
            return "/movie/\(id)"
        case .search:
            return "/search/movie"
        case .similar(let id, _):
            return "/movie/\(id)/similar"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .topRated(let page):
            return [
                .init(name: "page", value: "\(page)"),
                .init(name: "language", value: AppConfig.defaultLanguage)
            ]
        case .movieDetails:
            return [
                .init(name: "language", value: AppConfig.defaultLanguage)
            ]
        case .search(let q, let page):
            return [
                .init(name: "query", value: q),
                .init(name: "page", value: "\(page)"),
                .init(name: "language", value: AppConfig.defaultLanguage),
                .init(name: "include_adult", value: "false")
            ]
        case .similar(_, let page):
            return [
                .init(name: "page", value: "\(page)"),
                .init(name: "language", value: AppConfig.defaultLanguage)
            ]
        }
    }
}
