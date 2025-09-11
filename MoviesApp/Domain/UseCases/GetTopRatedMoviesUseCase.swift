//
//  GetTopRatedMoviesUseCase.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import Foundation

struct GetTopRatedMoviesUseCase {
    let repo: MoviesRepository
    func execute(page: Int) async throws -> (movies: [Movie], totalPages: Int) {
        let dto: PageDTO<MovieDTO> = try await repo.topRated(page: page)
        
        return (dto.results.map { $0.toDomain() }, dto.totalPages)
    }
}
