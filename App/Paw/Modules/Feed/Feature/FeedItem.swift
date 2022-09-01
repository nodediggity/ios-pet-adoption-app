//
//  FeedItem.swift
//  Paw
//
//  Created by Gordon Smith on 01/09/2022.
//

import Foundation

public struct FeedItem: Equatable {
    public let id: UUID
    public let category: Category
    public let name: String
    public let breed: String
    public let age: String
    public let weight: String
    public let imageURL: URL

    public enum Category: Equatable {
        case dog
        case cat
        case other(String)
    }
    
    public init(id: UUID, category: FeedItem.Category, name: String, breed: String, age: String, weight: String, imageURL: URL) {
        self.id = id
        self.category = category
        self.name = name
        self.breed = breed
        self.age = age
        self.weight = weight
        self.imageURL = imageURL
    }
    
}
