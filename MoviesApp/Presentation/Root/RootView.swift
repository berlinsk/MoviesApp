//
//  RootView.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import SwiftUI

struct RootView: View {
    let topRatedVM: TopRatedViewModel
    let searchVM: SearchViewModel
    let favoritesVM: FavoritesViewModel

    var body: some View {
        TabView {
            TopRatedView(vm: topRatedVM)
                .tabItem {
                    Label("Top", systemImage: "film")
                }

            NavigationView {
                SearchView(vm: searchVM)
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }

            FavoritesView(vm: favoritesVM)
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
        }
    }
}
