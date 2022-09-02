//
//  FeedUIIntegrationTests+Assertions.swift
//  PawTests
//
//  Created by Gordon Smith on 02/09/2022.
//

import XCTest
import Paw

extension FeedUIIntegrationTests {
    func assertThat(_ sut: CollectionViewController, isRendering feed: [FeedItem], file: StaticString = #filePath, line: UInt = #line) {
        sut.view.enforceLayoutCycle()
        
        guard sut.numberOfRenderedItems() == feed.count else {
            return XCTFail("Expected \(feed.count) items but got \(sut.numberOfRenderedItems()) instead.", file: file, line: line)
        }
        
        feed.enumerated().forEach { index, item in
            assertThat(sut, hasViewConfiguredFor: item, at: IndexPath(item: index, section: 0), file: file, line: line)
        }
        
        executeRunLoopToCleanUpReferences()
    }
}

private extension FeedUIIntegrationTests {
    
    func assertThat(_ sut: CollectionViewController, hasViewConfiguredFor item: FeedItem, at indexPath: IndexPath, file: StaticString = #filePath, line: UInt = #line) {
        let cell = sut.cell(at: indexPath)
        guard let view = cell as? PetGridViewCell else {
            return XCTFail("Expected `PetGridViewCell` for \(indexPath) but got \(type(of: cell)) instead", file: file, line: line)
        }
        
        let viewModel = FeedItemPresenter.map(item)
        
        XCTAssertEqual(view.nameText, viewModel.name, file: file, line: line)
        XCTAssertEqual(view.ageText, viewModel.age, file: file, line: line)
        XCTAssertEqual(view.breedText, viewModel.breed, file: file, line: line)
    }
    
    func executeRunLoopToCleanUpReferences() {
        RunLoop.current.run(until: Date())
    }
}
