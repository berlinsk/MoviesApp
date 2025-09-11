//
//  SearchMoviesUseCase.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import Foundation

struct SearchMoviesUseCase {
    let repo: MoviesRepository
    func execute(query: String, page: Int) async throws -> (movies: [Movie], totalPages: Int) {
        let dto: PageDTO<MovieDTO> = try await repo.search(query: query, page: page)
        
        return (dto.results.map { $0.toDomain() }, dto.totalPages)
    }
}
