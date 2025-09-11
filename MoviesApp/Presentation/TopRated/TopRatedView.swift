//
//  TopRatedView.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import SwiftUI

struct TopRatedView: View {
    @StateObject var vm: TopRatedViewModel
    @EnvironmentObject var theme: ThemeManager

    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        NavigationView {
            Group {
                if vm.movies.isEmpty && vm.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(vm.movies, id: \.id) { m in
                                NavigationLink(
                                    destination: MovieDetailsView(
                                        vm: ViewModelFactory.movieDetailsVM(id: m.id)
                                    )
                                ) {
                                    MovieCardView(
                                        title: m.title,
                                        rating: m.voteAverage,
                                        posterPath: m.posterPath,
                                        isFavorite: vm.isFavorite(m.id),
                                        onToggleFavorite: {
                                            vm.onToggleFavorite(m.id)
                                        }
                                    )
                                }
                                .buttonStyle(.plain)
                                .onAppear {
                                    Task {
                                        await vm.loadNextBatchIfNeeded(item: m)
                                    }
                                }
                            }
                        }
                        .padding(16)
                        if vm.isLoading {
                            ProgressView().padding(.vertical, 16)
                        }
                    }
                    .refreshable {
                        await vm.refresh()
                    }
                }
            }
            .navigationTitle("Movie")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Text(vm.averageText).font(.subheadline).foregroundColor(.secondary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SearchView(vm: nil)) {
                        Image(systemName: "magnifyingglass")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        ForEach(AppTheme.allCases) { themeCase in
                            Button(themeCase.title) {
                                theme.set(themeCase)
                            }
                        }
                    } label: {
                        Image(systemName: "sun.max")
                    }
                }
            }
            .task {
                if vm.movies.isEmpty {
                    await vm.refresh()
                }
            }
            .alert("Error", isPresented: .constant(vm.errorText != nil), actions: {
                Button("OK") {
                    vm.errorText = nil
                }
            }, message: {
                Text(vm.errorText ?? "")
            })
        }
        .navigationViewStyle(.stack)
    }
}
