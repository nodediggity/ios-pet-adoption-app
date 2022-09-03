//
// ImageDataResponseMapperTests.swift
//

import Paw
import XCTest

class ImageDataResponseMapperTests: XCTestCase {
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let samples = [199, 201, 300, 400, 500]

        try samples.forEach { code in
            XCTAssertThrowsError(
                try ImageDataResponseMapper.map(makeData(str: "any data"), from: HTTPURLResponse(statusCode: code))
            )
        }
    }

    func test_map_deliversInvalidDataErrorOn200HTTPResponseWithEmptyData() {
        let emptyData = Data()

        XCTAssertThrowsError(
            try ImageDataResponseMapper.map(emptyData, from: HTTPURLResponse(statusCode: 200))
        )
    }

    func test_map_deliversReceivedNonEmptyDataOn200HTTPResponse() throws {
        let nonEmptyData = Data("non-empty data".utf8)

        let result = try ImageDataResponseMapper.map(nonEmptyData, from: HTTPURLResponse(statusCode: 200))

        XCTAssertEqual(result, nonEmptyData)
    }
}
