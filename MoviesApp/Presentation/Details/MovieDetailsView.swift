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
            if let d = vm.details {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        MovieCardView(
                            title: d.title,
                            rating: d.voteAverage,
                            posterPath: d.posterPath,
                            isFavorite: vm.isFavorite,
                            onToggleFavorite: vm.onToggleFavorite
                        )
                        .padding(.horizontal, 16)

                        Text("Release: \(d.releaseDate ?? "-")")
                            .font(.subheadline).foregroundColor(.secondary)
                            .padding(.horizontal, 16)

                        Text(d.overview).padding(.horizontal, 16)
                    }
                }
            } else if vm.isLoading {
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Text("No data")
            }
        }
        .navigationTitle("Details")
        .task {
            await vm.load()
        }
        .alert("Error", isPresented: .constant(vm.errorText != nil), actions: {
            Button("OK") {
                vm.errorText = nil
            }
        }, message: {
            Text(vm.errorText ?? "")
        })
    }
}
