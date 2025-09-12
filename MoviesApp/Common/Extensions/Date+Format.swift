//
//  Date+Format.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 12.09.2025.
//

import Foundation

extension String {
    func tmdbDateToDisplay() -> String {
        let inFmt = DateFormatter()
        inFmt.calendar = Calendar(identifier: .gregorian)
        inFmt.locale = Locale(identifier: "en_US_POSIX")
        inFmt.dateFormat = "yyyy-MM-dd"

        guard let date = inFmt.date(from: self) else {
            return self
        }

        let outFmt = DateFormatter()
        outFmt.calendar = Calendar(identifier: .gregorian)
        outFmt.locale = Locale(identifier: "en_US_POSIX")
        outFmt.dateFormat = "dd MMMM yyyy"

        return outFmt.string(from: date).lowercased()
    }
}
