//
//  MoviesAppApp.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import SwiftUI

@main
struct MoviesApp: App {
    @StateObject private var theme = ThemeManager()

    var body: some Scene {
        WindowGroup {
            RootView(
                topRatedVM: ViewModelFactory.topRatedVM,
                searchVM: ViewModelFactory.searchVM,
                favoritesVM: ViewModelFactory.favoritesVM
            )
            .environmentObject(theme)
            .preferredColorScheme(theme.selected.colorScheme)
        }
    }
}
