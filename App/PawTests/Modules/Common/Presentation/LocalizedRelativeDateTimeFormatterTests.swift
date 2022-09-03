//
// LocalizedRelativeDateTimeFormatterTests.swift
//

import Paw
import XCTest

class LocalizedRelativeDateTimeFormatterTests: XCTestCase {
    func test_returnsInOneDayWhenDatesFarApart() {
        let april_28_2020 = Date(timeIntervalSince1970: 1_619_613_657)
        let april_27_2020 = Date(timeIntervalSince1970: 1_619_527_257)
        let sut = LocalizedRelativeDateTimeFormatter(currentDate: { april_27_2020 })

        XCTAssertEqual(sut.string(for: april_28_2020), "in 1 day")
    }

    func test_returnsTimeAgoWhenDatesFarApart() {
        let april_28_2020 = Date(timeIntervalSince1970: 1_619_613_657)
        let april_27_2020 = Date(timeIntervalSince1970: 1_619_527_257)
        let sut = LocalizedRelativeDateTimeFormatter(currentDate: { april_28_2020 })

        XCTAssertEqual(sut.string(for: april_27_2020), "1 day ago")
    }

    func test_returnsJustNowWhenDatesAreLessThan1SecondApart() {
        let april_28_2020 = Date(timeIntervalSince1970: 1_619_613_657)
        let sut = LocalizedRelativeDateTimeFormatter(currentDate: { april_28_2020 })

        XCTAssertEqual(sut.string(for: april_28_2020), "Just now")
    }

    func test_returns1SecondAgoWhenDatesAre1SecondApart() {
        let april_28_2020 = Date(timeIntervalSince1970: 1_619_613_657)
        let one_second_earlier = april_28_2020.addingTimeInterval(-1)
        let sut = LocalizedRelativeDateTimeFormatter(currentDate: { april_28_2020 })

        XCTAssertEqual(sut.string(for: one_second_earlier), "1 second ago")
    }
}
