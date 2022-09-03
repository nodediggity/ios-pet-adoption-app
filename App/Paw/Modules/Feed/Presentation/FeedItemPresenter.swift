//
// FeedItemPresenter.swift
//

import Foundation

public enum FeedItemPresenter {
    public static func map(_ item: FeedItem) -> FeedItemViewModel {
        FeedItemViewModel(name: item.name, age: item.age, breed: item.breed)
    }
}
