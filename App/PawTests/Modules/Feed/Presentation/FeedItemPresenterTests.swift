//
//  FeedItemPresenterTests.swift
//  PawTests
//
//  Created by Gordon Smith on 02/09/2022.
//

import XCTest
import Paw

class FeedItemPresenterTests: XCTestCase {
    
    func test_map_createsViewModel() {
        let item = makeItem()
        
        let viewModel = FeedItemPresenter.map(item)
        
        XCTAssertEqual(viewModel.name, item.name)
        XCTAssertEqual(viewModel.age, item.age)
        XCTAssertEqual(viewModel.breed, item.breed)
    }
    
}

private extension FeedItemPresenterTests {
    func makeItem(id: UUID = UUID(), category: FeedItem.Category = .dog) -> FeedItem {
        FeedItem(
            id: id,
            category: category,
            name: "any name \(id.uuidString)",
            breed: "any breed \(id.uuidString)",
            age: "any age \(id.uuidString)",
            weight: "any weight \(id.uuidString)",
            imageURL: makeURL(addr: "https://image.com/\(id.uuidString)")
        )
    }
}
