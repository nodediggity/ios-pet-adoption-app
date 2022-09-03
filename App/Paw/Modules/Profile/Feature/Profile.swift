//
// Profile.swift
//

import Foundation

public struct Profile: Equatable, Hashable {
    public let id: UUID
    public let name: String
    public let tags: [String]
    public let about: String
    public let lastUpdatedDate: Date
    public let imageURL: URL
    public let isAvailable: Bool

    public init(id: UUID, name: String, tags: [String], about: String, lastUpdatedDate: Date, imageURL: URL, isAvailable: Bool) {
        self.id = id
        self.name = name
        self.tags = tags
        self.about = about
        self.lastUpdatedDate = lastUpdatedDate
        self.imageURL = imageURL
        self.isAvailable = isAvailable
    }
}
