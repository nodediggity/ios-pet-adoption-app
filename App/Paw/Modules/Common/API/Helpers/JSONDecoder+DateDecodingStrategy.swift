//
// JSONDecoder+DateDecodingStrategy.swift
//

import Foundation

public extension JSONDecoder.DateDecodingStrategy {
    struct UnexpectedDataFormat: Error { }

    static let api = custom {
        let container = try $0.singleValueContainer()
        let string = try container.decode(String.self)

        if let date = Formatter.iso8601withFractionalSeconds.date(from: string) {
            return date
        }

        throw UnexpectedDataFormat()
    }
}

public extension Formatter {
    static let iso8601withFractionalSeconds: DateFormatter = makeDateFormatter(usingFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX")

    private static func makeDateFormatter(usingFormat format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = format
        return formatter
    }
}
