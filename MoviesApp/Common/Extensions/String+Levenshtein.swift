//
//  String+Levenshtein.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 12.09.2025.
//

import Foundation

extension String {
    func levenshteinDistance(to target: String) -> Int {
        let sourceArray = Array(self.lowercased())
        let targetArray = Array(target.lowercased())
        let (n, m) = (sourceArray.count, targetArray.count)

        guard n > 0 else {
            return m
        }
        guard m > 0 else {
            return n
        }

        var matrix = Array(repeating: Array(repeating: 0, count: m + 1), count: n + 1)

        for i in 0...n {
            matrix[i][0] = i
        }
        for j in 0...m {
            matrix[0][j] = j
        }

        for i in 1...n {
            for j in 1...m {
                if sourceArray[i - 1] == targetArray[j - 1] {
                    matrix[i][j] = matrix[i - 1][j - 1]
                } else {
                    matrix[i][j] = Swift.min(
                        matrix[i - 1][j] + 1,   // deletion
                        Swift.min(
                            matrix[i][j - 1] + 1,   // insertion
                            matrix[i - 1][j - 1] + 1    // substitution
                        )
                    )
                }
            }
        }

        return matrix[n][m]
    }

    // similarity ratio in range [0.0, 1.0] (1.0 = exact match)
    func similarity(to target: String) -> Double {
        let distance = levenshteinDistance(to: target)
        let maxLen = max(self.count, target.count)
        return maxLen == 0 ? 1.0 : 1.0 - (Double(distance) / Double(maxLen))
    }
}
