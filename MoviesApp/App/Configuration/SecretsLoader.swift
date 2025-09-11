//
//  SecretsLoader.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import Foundation

enum SecretsLoader {
    static var apiKey: String {
        guard
            let url = Bundle.main.url(forResource: "Secrets.private", withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let dict = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
            let key = dict["TMDB_API_KEY"] as? String
        else {
            fatalError("Secrets.private.plist not configured. Copy Secrets.public.plist and add TMDB_API_KEY")
        }
        return key
    }
}
