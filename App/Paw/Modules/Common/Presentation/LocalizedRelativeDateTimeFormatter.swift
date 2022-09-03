//
//  LocalizedRelativeDateTimeFormatter.swift
//  Paw
//
//  Created by Gordon Smith on 02/09/2022.
//

import Foundation

public final class LocalizedRelativeDateTimeFormatter {
    let currentDate: () -> Date
    let calendar: Calendar
    let locale: Locale

    public init(currentDate: @escaping () -> Date = Date.init, calendar: Calendar = .current, locale: Locale = .current) {
        self.currentDate = currentDate
        self.calendar = calendar
        self.locale = locale
    }

    public func string(for date: Date) -> String {
        let now = currentDate()
        let secondsDifference = Int(now.timeIntervalSince(date))
        guard secondsDifference != 0 else { return "Just now" }

        let dateFormatter = RelativeDateTimeFormatter()
        dateFormatter.calendar = calendar
        dateFormatter.locale = locale

        return dateFormatter.localizedString(for: date, relativeTo: now)
    }
}
