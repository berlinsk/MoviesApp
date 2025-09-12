//
//  SecretsLoader.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import Foundation

enum SecretsLoader {
    static var apiKey: String {
        if let url = Bundle.main.url(forResource: "Secrets.private", withExtension: "plist"),
           let data = try? Data(contentsOf: url),
           let dict = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
           let key = dict["TMDB_API_KEY"] as? String {
            return key
        }

        if let url = Bundle.main.url(forResource: "Secrets.public", withExtension: "plist"),
           let data = try? Data(contentsOf: url),
           let dict = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
           let key = dict["TMDB_API_KEY"] as? String {
            return key
        }

        assertionFailure("No TMDB_API_KEY found in Secrets.private.plist or Secrets.public.plist")
        return ""
    }
}
