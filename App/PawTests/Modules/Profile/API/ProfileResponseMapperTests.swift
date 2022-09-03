//
// ProfileResponseMapperTests.swift
//

import Paw
import XCTest

class ProfileResponseMapperTests: XCTestCase {
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeJSON([:])
        let samples = [199, 201, 300, 400, 500]

        try samples.forEach { code in
            XCTAssertThrowsError(
                try ProfileResponseMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }

    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("some invalid json".utf8)

        XCTAssertThrowsError(
            try ProfileResponseMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }

    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        let item = makeItem()
        let json = makeJSON(item.json)

        let result = try ProfileResponseMapper.map(json, from: HTTPURLResponse(statusCode: 200))

        XCTAssertEqual(result, item.model)
    }
}

private extension ProfileResponseMapperTests {
    func makeJSON(_ json: [String: Any]) -> Data {
        try! JSONSerialization.data(withJSONObject: json)
    }

    func makeItem(id: UUID = UUID()) -> (model: Profile, json: [String: Any]) {
        let imageURL = makeURL(addr: "https://image.com/\(id.uuidString)")
        let updated = (date: 1_600_250_504.489, string: "2020-09-16T10:01:44.489Z")

        let model = Profile(
            id: id,
            name: "any name",
            tags: ["tag #1", "tag #2"],
            about: "any body text",
            lastUpdatedDate: Date(timeIntervalSince1970: updated.date),
            imageURL: imageURL.absoluteURL,
            isAvailable: true
        )

        let json = [
            "id": model.id.uuidString,
            "name": model.name,
            "tags": model.tags,
            "about": model.about,
            "lastUpdatedDate": updated.string,
            "isAvailable": true,
            "imageURL": imageURL.absoluteString
        ] as [String: Any]

        return (model, json)
    }
}
