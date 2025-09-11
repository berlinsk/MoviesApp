//
//  NetworkClient.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import Foundation

final class NetworkClient {
    private let baseURL = AppConfig.baseURL
    private let apiKey = SecretsLoader.apiKey
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Decodable>(_ api: TMDBAPI) async throws -> T {
        var components = URLComponents(url: baseURL.appendingPathComponent(api.path), resolvingAgainstBaseURL: false)!
        components.queryItems = api.queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw HTTPError.invalidResponse
        }
        guard 200..<300 ~= http.statusCode else {
            throw HTTPError.status(http.statusCode)
        }

        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
