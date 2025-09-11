//
//  ThemeManager.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import SwiftUI

final class ThemeManager: ObservableObject {
    @AppStorage("app_theme") private var storedTheme: Int = AppTheme.system.rawValue {
        didSet {
            selected = AppTheme(rawValue: storedTheme) ?? .system
        }
    }
    @Published var selected: AppTheme = .system

    init() {
        selected = AppTheme(rawValue: storedTheme) ?? .system
    }

    func set(_ theme: AppTheme) {
        storedTheme = theme.rawValue
    }
}
