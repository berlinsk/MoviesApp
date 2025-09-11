//
//  AppConfig.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import Foundation

enum AppConfig {
    static let baseURL = URL(string: "https://api.themoviedb.org/3")!
    static let imagesBaseURL = URL(string: "https://image.tmdb.org/t/p/w500")!
    static let defaultLanguage = "en-US"
}
