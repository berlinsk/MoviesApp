//
//  Movie.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import Foundation

struct Movie {
    let id: Int
    let title: String
    let posterPath: String?
    let voteAverage: Double
    let overview: String
    let releaseDate: String?
}

extension MovieDTO {
    func toDomain() -> Movie {
        Movie(
            id: id,
            title: title,
            posterPath: posterPath,
            voteAverage: voteAverage,
            overview: overview,
            releaseDate: releaseDate
        )
    }
}
