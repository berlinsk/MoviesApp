//
//  HTTPError.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 11.09.2025.
//

import Foundation

enum HTTPError: Error {
    case invalidResponse
    case status(Int)
}
