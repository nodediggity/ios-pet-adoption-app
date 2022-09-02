//
//  FeedItemPresenter.swift
//  Paw
//
//  Created by Gordon Smith on 02/09/2022.
//

import Foundation

public enum FeedItemPresenter {
    public static func map(_ item: FeedItem) -> FeedItemViewModel {
        FeedItemViewModel(name: item.name, age: item.age, breed: item.breed)
    }
}
