//
//  SearchViewModel.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var query = ""
    @Published private(set) var results: [Movie] = []
    @Published var isLoading = false
    @Published var errorText: String?

    private let searchMovies: SearchMoviesUseCase
    private let favorites: FavoritesRepository
    private let toggleFavorite: ToggleFavoriteUseCase

    private var cancellables = Set<AnyCancellable>()
    private var page = 1
    private var totalPages = 1
    private var resolvedQuery: String? // corrected (fuzzy)search query

    init(searchMovies: SearchMoviesUseCase,
         favorites: FavoritesRepository,
         toggleFavorite: ToggleFavoriteUseCase) {
        self.searchMovies = searchMovies
        self.favorites = favorites
        self.toggleFavorite = toggleFavorite

        $query
            .removeDuplicates()
            .debounce(for: .milliseconds(350), scheduler: RunLoop.main)
            .sink { [weak self] text in
                Task {
                    await self?.performSearch(text: text)
                }
            }
            .store(in: &cancellables)
    }

    func isFavorite(_ id: Int) -> Bool {
        favorites.isFavorite(id: id)
    }
    func onToggleFavorite(_ id: Int) {
        toggleFavorite.execute(id: id)
        objectWillChange.send()
    }

    func loadMoreIfNeeded(item: Movie) async {
        guard item.id == results.suffix(4).first?.id, page < totalPages, !isLoading else {
            return
        }
        page += 1
        await search(page: page)
    }

    private func performSearch(text: String) async {
        guard text.count >= 3 else {
            results = []
            return
        }
        page = 1
        totalPages = 1
        resolvedQuery = nil
        results = []
        await search(page: page)
    }


    private func search(page: Int) async {
        isLoading = true
        defer {
            isLoading = false
        }

        let baseQuery = resolvedQuery ?? query

        do {
            let response = try await searchMovies.execute(query: baseQuery, page: page)

            if page == 1, response.movies.isEmpty {
                // candidates from whole phrase
                let comboCandidates = FuzzyQuery.candidates(from: query, perTokenLimit: .max, limit: 50)

                //strong fallback: single tokens (longest first) + transpositions
                let tokens = FuzzyQuery.tokens(from: query).sorted { $0.count > $1.count }
                var tokenCandidates: [String] = []
                for token in tokens {
                    tokenCandidates.appendIfAbsent(token)
                    for transposed in FuzzyQuery.transpositions(of: token) {
                        tokenCandidates.appendIfAbsent(transposed)
                    }
                }

                // merge candidates, token-based first
                let allCandidates = (tokenCandidates + comboCandidates).removingDuplicatesCI()

                for candidate in allCandidates where !equalsCI(candidate, baseQuery) {
                    let altResponse = try await searchMovies.execute(query: candidate, page: 1)
                    if !altResponse.movies.isEmpty {
                        resolvedQuery = candidate
                        totalPages = altResponse.totalPages
                        let sorted = altResponse.movies.sorted {
                            $0.title.similarity(to: query) > $1.title.similarity(to: query)
                        }
                        results.append(contentsOf: sorted)
                        return
                    }
                }
            }

            // normal path or no fallback results
            totalPages = response.totalPages
            let sorted = response.movies.sorted {
                $0.title.similarity(to: query) > $1.title.similarity(to: query)
            }
            results.append(contentsOf: sorted)
        } catch {
            errorText = String(describing: error)
        }
    }

    private func equalsCI(_ lhs: String, _ rhs: String) -> Bool {
        lhs.caseInsensitiveCompare(rhs) == .orderedSame
    }
}
