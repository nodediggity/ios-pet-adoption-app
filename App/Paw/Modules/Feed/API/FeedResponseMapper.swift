//
//  FeedResponseMapper.swift
//  Paw
//
//  Created by Gordon Smith on 01/09/2022.
//

import Foundation

public enum FeedResponseMapper {
    public struct InvalidResponseError: Error { }

    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [FeedItem] {
        let decoder = JSONDecoder()
        guard isOK(response), let root = try? decoder.decode(Root.self, from: data) else {
            throw InvalidResponseError()
        }

        return root.content.asFeedItems
    }
}

private extension FeedResponseMapper {
    static var OK_200: Int { 200 }

    static func isOK(_ response: HTTPURLResponse) -> Bool {
        response.statusCode == OK_200
    }

    struct Root: Decodable {
        let content: [Item]

        struct Item: Decodable {
            let id: UUID
            let category: String
            let name: String
            let breed: String
            let age: String
            let weight: String
            let imageURL: URL
        }
    }
}

private extension Array where Element == FeedResponseMapper.Root.Item {
    var asFeedItems: [FeedItem] {
        map { remote in
            FeedItem(
                id: remote.id,
                category: mapCategory(from: remote.category),
                name: remote.name,
                breed: remote.breed,
                age: remote.age,
                weight: remote.weight,
                imageURL: remote.imageURL
            )
        }
    }

    private func mapCategory(from str: String) -> FeedItem.Category {
        switch str {
        case "DOG": return .dog
        case "CAT": return .cat
        default: return .other(str)
        }
    }
}
