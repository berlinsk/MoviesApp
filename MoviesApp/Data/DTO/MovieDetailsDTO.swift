//
//  MovieDetailsDTO.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import Foundation

struct MovieDetailsDTO: Decodable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String?
    let posterPath: String?
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
}

extension MovieDetailsDTO {
    func toDomain() -> MovieDetails {
        .init(id: id, title: title, overview: overview,
              releaseDate: releaseDate, posterPath: posterPath,
              voteAverage: voteAverage)
    }
}
