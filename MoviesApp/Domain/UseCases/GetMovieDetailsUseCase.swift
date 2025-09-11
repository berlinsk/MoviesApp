//
//  GetMovieDetailsUseCase.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import Foundation

struct GetMovieDetailsUseCase {
    let repo: MoviesRepository
    func execute(id: Int) async throws -> MovieDetails {
        try await repo.details(id: id).toDomain()
    }
}
