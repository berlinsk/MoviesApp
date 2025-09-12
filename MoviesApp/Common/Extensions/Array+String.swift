//
//  Array+String.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 12.09.2025.
//

import Foundation

extension Array where Element == String {
    mutating func appendIfAbsent(_ value: String) {
        if !self.contains(where: { $0.caseInsensitiveCompare(value) == .orderedSame }) {
            self.append(value)
        }
    }
    
    func removingDuplicatesCI() -> [String] {
        var seen = Set<String>()
        var result: [String] = []
        for string in self {
            let key = string.lowercased()
            if seen.insert(key).inserted {
                result.append(string)
            }
        }
        return result
    }
}
