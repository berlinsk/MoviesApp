//
//  MovieDTO.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import Foundation

struct MovieDTO: Decodable {
    let id: Int
    let title: String
    let posterPath: String?
    let voteAverage: Double?
    let overview: String
    let releaseDate: String?

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
    }
}

extension MovieDTO {
    func toDomain() -> Movie {
        Movie(
            id: id,
            title: title,
            posterPath: posterPath,
            voteAverage: voteAverage ?? 0.0,
            overview: overview,
            releaseDate: releaseDate
        )
    }
}
