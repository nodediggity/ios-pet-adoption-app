//
// ProfileResponseMapper.swift
//

import Foundation

public enum ProfileResponseMapper {
    public struct InvalidResponseError: Error { }

    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> Profile {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .api
        guard isOK(response), let root = try? decoder.decode(Root.self, from: data) else {
            throw InvalidResponseError()
        }

        return root.asProfile
    }
}

private extension ProfileResponseMapper {
    static var OK_200: Int { 200 }

    static func isOK(_ response: HTTPURLResponse) -> Bool {
        response.statusCode == OK_200
    }

    struct Root: Decodable {
        let id: UUID
        let name: String
        let about: String
        let lastUpdatedDate: Date
        let imageURL: URL
        let isAvailable: Bool
        let tags: [String]

        var asProfile: Profile {
            Profile(
                id: id,
                name: name,
                tags: tags,
                about: about,
                lastUpdatedDate: lastUpdatedDate,
                imageURL: imageURL,
                isAvailable: isAvailable
            )
        }
    }
}
