//
//  FeedUIIntegrationTests.swift
//  PawTests
//
//  Created by Gordon Smith on 02/09/2022.
//

import XCTest
@testable import Paw

class FeedUIIntegrationTests: XCTestCase {
    
    // MARK: - Feed Loading
    
    func test_loadActions_requestFromLoader() {
        let (sut, spy) = makeSUT()
        
        XCTAssertEqual(spy.loadFeedCallCount, 0)
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(spy.loadFeedCallCount, 1)
        
        spy.completeFeedLoading(with: .failure(makeError()))
        
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(spy.loadFeedCallCount, 2)
    }
    
    func test_loadingIndicator_isVisibleWhileLoading() {
        let (sut, spy) = makeSUT()
        
        let error = makeError()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator)
        
        spy.completeFeedLoading(with: .failure(error))
        XCTAssertFalse(sut.isShowingLoadingIndicator)
        
        sut.simulateUserInitiatedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator)
        
        spy.completeFeedLoading(with: .failure(error), at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator)
        
        sut.simulateUserInitiatedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator)
        
        let feed = [makeItem(category: .dog), makeItem(category: .cat)]
        spy.completeFeedLoading(with: .success(feed), at: 2)
        XCTAssertFalse(sut.isShowingLoadingIndicator)
    }
    
    func test_loadCompletion_rendersSuccessfully() {
        let (sut, spy) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        assertThat(sut, isRendering: [])
        
        spy.completeFeedLoading(with: .success([]))
        
        assertThat(sut, isRendering: [])
        
        sut.simulateUserInitiatedReload()
        
        let feed = [makeItem(category: .dog), makeItem(category: .cat)]
        
        spy.completeFeedLoading(with: .success(feed), at: 1)
        assertThat(sut, isRendering: feed)
        
        sut.simulateUserInitiatedReload()
        
        let refreshedFeed = [makeItem(category: .dog), makeItem(category: .cat), makeItem(category: .dog)]
        spy.completeFeedLoading(with: .success(refreshedFeed), at: 2)
        
        assertThat(sut, isRendering: refreshedFeed)
    }
    
    func test_loadCompletion_rendersSuccessfullyLoadedEmptyFeedAfterNonEmptyFeed() {
        let (sut, spy) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        let feed = [makeItem(category: .dog)]
        spy.completeFeedLoading(with: .success(feed))
        
        assertThat(sut, isRendering: feed)
        
        sut.simulateUserInitiatedReload()
        
        spy.completeFeedLoading(with: .success([]), at: 1)
        
        assertThat(sut, isRendering: [])
    }
    
    func test_loadCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let (sut, spy) = makeSUT()

        sut.loadViewIfNeeded()

        let feed = [makeItem(category: .dog)]
        spy.completeFeedLoading(with: .success(feed))

        assertThat(sut, isRendering: feed)

        sut.simulateUserInitiatedReload()

        let error = makeError()
        spy.completeFeedLoading(with: .failure(error), at: 1)

        assertThat(sut, isRendering: feed)
    }
    
    func test_loadCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, spy) = makeSUT()

        sut.loadViewIfNeeded()

        let feed = [makeItem(category: .dog)]
        let exp = expectation(description: "await background queue")
        DispatchQueue.global().async {
            spy.completeFeedLoading(with: .success(feed))
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
}

private extension FeedUIIntegrationTests {
    func makeSUT(file: StaticString = #filePath, line: UInt = #line, selection: @escaping (FeedItem) -> Void = { _ in }) -> (sut: CollectionViewController, spy: LoaderSpy) {
        let spy = LoaderSpy()
        let sut = FeedUIComposer.compose(loader: spy.load)
        
        trackForMemoryLeaks(spy, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, spy)
    }
    
    func makeItem(id: UUID = UUID(), category: FeedItem.Category) -> FeedItem {
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
