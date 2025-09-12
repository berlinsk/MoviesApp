//
//  FuzzyQuery.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 12.09.2025.
//

import Foundation

struct FuzzyQuery {

    // tokenize string into alphanumeric words
    static func tokens(from text: String) -> [String] {
        text.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            .split(whereSeparator: { !$0.isLetter && !$0.isNumber })
            .map(String.init)
    }

    // generate adjacent-char transpositions (Damerau-style)
    static func transpositions(of word: String) -> [String] {
        guard word.count >= 2 else {
            return []
        }
        var variants: [String] = []
        var chars = Array(word)
        for i in 0..<(chars.count - 1) {
            chars.swapAt(i, i + 1)
            variants.append(String(chars))
            chars.swapAt(i, i + 1)
        }
        return variants
    }

    // generate candidate strings with typo tolerance
    static func candidates(from input: String, perTokenLimit: Int = .max, limit: Int = 50) -> [String] {
        let normalized = normalize(input)
        let queryTokens = tokens(from: normalized)
        guard !queryTokens.isEmpty else {
            return [normalized]
        }

        let perTokenVariants: [[String]] = queryTokens.map { token in
            var variants: [String] = [token]
            for transposed in transpositions(of: token) {
                variants.appendIfAbsent(transposed)
            }
            return variants
        }

        var allCombinations: [String] = []
        combine(perTokenVariants, index: 0, current: [], output: &allCombinations, hardLimit: limit * 4)
        let unique = uniquePreservingOrder(allCombinations)

        let scored: [String] = unique
            .map { candidate in
                (candidate, changeCost(originalTokens: queryTokens, candidate: candidate))
            }
            .sorted { lhs, rhs in
                if lhs.1 != rhs.1 {
                    return lhs.1 < rhs.1
                }
                return lhs.0.count < rhs.0.count
            }
            .map { $0.0 }

        var result: [String] = []
        result.appendIfAbsent(normalized)
        for candidate in scored {
            result.appendIfAbsent(candidate)
            if result.count >= limit {
                break
            }
        }
        return result
    }

    private static func normalize(_ text: String) -> String {
        let folded = text.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
        let collapsed = folded.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        return collapsed.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func combine(_ lists: [[String]], index: Int, current: [String], output: inout [String], hardLimit: Int) {
        if output.count >= hardLimit {
            return
        }
        if index == lists.count {
            output.append(current.joined(separator: " "))
            return
        }
        for variant in lists[index] {
            combine(lists, index: index + 1, current: current + [variant], output: &output, hardLimit: hardLimit)
            if output.count >= hardLimit {
                return
            }
        }
    }

    private static func changeCost(originalTokens: [String], candidate: String) -> Int {
        let candTokens = tokens(from: candidate)
        let n = min(originalTokens.count, candTokens.count)
        var diff = 0
        for i in 0..<n {
            if originalTokens[i].caseInsensitiveCompare(candTokens[i]) != .orderedSame {
                diff += 1
            }
        }
        diff += abs(originalTokens.count - candTokens.count)
        return diff
    }

    private static func uniquePreservingOrder(_ items: [String]) -> [String] {
        var seen = Set<String>()
        var result: [String] = []
        for item in items {
            let key = item.lowercased()
            if seen.insert(key).inserted {
                result.append(item)
            }
        }
        return result
    }
}
