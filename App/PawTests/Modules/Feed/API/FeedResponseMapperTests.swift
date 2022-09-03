//
// FeedResponseMapperTests.swift
//

import Paw
import XCTest

class FeedResponseMapperTests: XCTestCase {
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeJSON([])
        let samples = [199, 201, 300, 400, 500]

        try samples.forEach { code in
            XCTAssertThrowsError(
                try FeedResponseMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }

    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("some invalid json".utf8)

        XCTAssertThrowsError(
            try FeedResponseMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }

    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeJSON([])

        let result = try FeedResponseMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))

        XCTAssertEqual(result, [])
    }

    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        let item0 = makeItem(id: UUID(), category: .dog)
        let item1 = makeItem(id: UUID(), category: .cat)
        let item2 = makeItem(id: UUID(), category: .other("FISH"))

        let json = makeJSON([item0.json, item1.json, item2.json])

        let result = try FeedResponseMapper.map(json, from: HTTPURLResponse(statusCode: 200))

        XCTAssertEqual(result, [item0.model, item1.model, item2.model])
    }
}

private extension FeedResponseMapperTests {
    func makeJSON(_ items: [[String: Any]]) -> Data {
        let json = ["content": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }

    func makeItem(id: UUID, category: FeedItem.Category) -> (model: FeedItem, json: [String: Any]) {
        let imageURL = makeURL(addr: "https://image.com/\(id.uuidString)")

        let model = FeedItem(
            id: id,
            category: category,
            name: "a name \(id.uuidString)",
            breed: "a breed \(id.uuidString)",
            age: "an age \(id.uuidString)",
            weight: "a weight \(id.uuidString)",
            imageURL: imageURL
        )

        let json = [
            "id": id.uuidString,
            "category": {
                switch category {
                case .dog: return "DOG"
                case .cat: return "CAT"
                case let .other(v): return v
                }
            }(),
            "name": model.name,
            "breed": model.breed,
            "age": model.age,
            "weight": model.weight,
            "imageURL": imageURL.absoluteString
        ]

        return (model, json)
    }
}
