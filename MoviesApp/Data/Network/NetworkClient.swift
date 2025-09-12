//
//  NetworkClient.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import Foundation
import Network

final class NetworkClient {
    private let baseURL = AppConfig.baseURL
    private let apiKey = SecretsLoader.apiKey
    private let session: URLSession
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    init(session: URLSession = .shared) {
        self.session = session
        monitor.start(queue: queue)
    }

    func request<T: Decodable>(_ api: TMDBAPI) async throws -> T {
        var components = URLComponents(
            url: baseURL.appendingPathComponent(api.path),
            resolvingAgainstBaseURL: false
        )!
        components.queryItems = api.queryItems

        var urlRequest = URLRequest(url: components.url!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await session.data(for: urlRequest)
            guard let http = response as? HTTPURLResponse else {
                throw HTTPError.invalidResponse
            }
            guard 200..<300 ~= http.statusCode else {
                throw HTTPError.status(http.statusCode)
            }
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                try await waitUntilOnline()
                return try await self.request(api)
            }
            throw error
        }
    }

    private func waitUntilOnline() async throws {
        try await withCheckedThrowingContinuation { continuation in
            monitor.pathUpdateHandler = { path in
                if path.status == .satisfied {
                    continuation.resume()
                }
            }
        }
    }
}
