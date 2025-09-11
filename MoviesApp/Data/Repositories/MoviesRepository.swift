//
//  MoviesRepository.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import Foundation

protocol MoviesRepository {
    func topRated(page: Int) async throws -> PageDTO<MovieDTO>
    func details(id: Int) async throws -> MovieDetailsDTO
    func search(query: String, page: Int) async throws -> PageDTO<MovieDTO>
    func similar(id: Int, page: Int) async throws -> PageDTO<MovieDTO>
}

final class DefaultMoviesRepository: MoviesRepository {
    private let client: NetworkClient
    init(client: NetworkClient) {
        self.client = client
    }

    func topRated(page: Int) async throws -> PageDTO<MovieDTO> {
        try await client.request(.topRated(page: page))
    }
    func details(id: Int) async throws -> MovieDetailsDTO {
        try await client.request(.movieDetails(id: id))
    }
    func search(query: String, page: Int) async throws -> PageDTO<MovieDTO> {
        try await client.request(.search(query: query, page: page))
    }
    func similar(id: Int, page: Int) async throws -> PageDTO<MovieDTO> {
        try await client.request(.similar(id: id, page: page))
    }
}
