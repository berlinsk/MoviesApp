//
//  AppTheme.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import SwiftUI

enum AppTheme: Int, CaseIterable, Identifiable {
    case system, light, dark
    var id: Int {
        rawValue
    }
    
    var iconName: String {
        self == .dark ? "moon" : "sun.max"
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }

    var title: String {
        switch self {
        case .system:
            return "System"
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }
}
