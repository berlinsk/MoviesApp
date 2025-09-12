//
//  MovieDetailsView.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import SwiftUI

struct MovieDetailsView: View {
    @StateObject var vm: MovieDetailsViewModel

    var body: some View {
        Group {
            if let details = vm.details {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        LargePosterView(posterPath: details.posterPath)
                            .padding(.horizontal, 24)
                            .padding(.top, 8)

                        Text(String(format: "Rating: %.1f", details.voteAverage))
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)

                        Text(details.overview)
                            .font(.body)
                            .lineSpacing(3)
                            .padding(.horizontal, 24)

                        Text((details.releaseDate ?? "-").tmdbDateToDisplay())
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 24)
                            .padding(.top, 4)

                        FavoriteButton(
                            isFavorite: vm.isFavorite,
                            addTitle: "Add to favorites",
                            removeTitle: "Remove from favorites",
                            action: vm.onToggleFavorite
                        )
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                        .padding(.bottom, 24)
                    }
                }
                .navigationTitle(details.title)
                .navigationBarTitleDisplayMode(.large)
            } else if vm.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Text("No data")
            }
        }
        .task {
            await vm.load()
        }
        .alert("Error", isPresented: .constant(vm.errorText != nil)) {
            Button("OK") {
                vm.errorText = nil
            }
        } message: {
            Text(vm.errorText ?? "")
        }
    }
}
