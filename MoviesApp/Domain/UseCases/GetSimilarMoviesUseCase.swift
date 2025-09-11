//
//  GetSimilarMoviesUseCase.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import Foundation

struct GetSimilarMoviesUseCase {
    let repo: MoviesRepository
    func execute(id: Int, page: Int) async throws -> [Movie] {
        let dto: PageDTO<MovieDTO> = try await repo.similar(id: id, page: page)
        
        return dto.results.map { $0.toDomain() }
    }
}
