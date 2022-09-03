//
// FeedUIIntegrationTests.swift
//

import UIKit
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

    // MARK: - Image Loading

    func test_itemImageView_loadsImageURLWhenVisible() {
        let item0 = makeItem(category: .dog)
        let item1 = makeItem(category: .cat)

        let (sut, spy) = makeSUT()

        sut.loadViewIfNeeded()

        let feed = [item0, item1]
        spy.completeFeedLoading(with: .success(feed))

        XCTAssertTrue(spy.loadImageRequests.isEmpty)

        sut.simulateFeedItemVisible(at: 0)

        XCTAssertEqual(spy.loadImageRequests, [item0.imageURL])

        sut.simulateFeedItemVisible(at: 1)

        XCTAssertEqual(spy.loadImageRequests, [item0.imageURL, item1.imageURL])
    }

    func test_itemImageView_cancelsImageLoadingWhenNotVisibleAnymore() {
        let item0 = makeItem(category: .dog)
        let item1 = makeItem(category: .cat)

        let (sut, spy) = makeSUT()

        sut.loadViewIfNeeded()

        let feed = [item0, item1]
        spy.completeFeedLoading(with: .success(feed))

        XCTAssertTrue(spy.cancelledRequests.isEmpty)

        sut.simulateFeedItemNotVisible(at: 0)

        XCTAssertEqual(spy.cancelledRequests, [item0.imageURL])

        sut.simulateFeedItemNotVisible(at: 1)

        XCTAssertEqual(spy.cancelledRequests, [item0.imageURL, item1.imageURL])
    }

    func test_itemImageView_rendersImageLoadedFromURL() {
        let item0 = makeItem(category: .dog)
        let item1 = makeItem(category: .cat)

        let (sut, spy) = makeSUT()

        sut.loadViewIfNeeded()

        let feed = [item0, item1]
        spy.completeFeedLoading(with: .success(feed))

        let view0 = sut.simulateFeedItemVisible(at: 0)
        let view1 = sut.simulateFeedItemVisible(at: 1)

        XCTAssertNil(view0?.renderedImage)
        XCTAssertNil(view1?.renderedImage)

        let imageData0 = UIImage.makeImageData(withColor: .red)
        spy.completeImageLoading(with: .success(imageData0))

        XCTAssertEqual(view0?.renderedImage, imageData0)
        XCTAssertNil(view1?.renderedImage)

        let imageData1 = UIImage.makeImageData(withColor: .blue)
        spy.completeImageLoading(with: .success(imageData1), at: 1)

        XCTAssertEqual(view0?.renderedImage, imageData0)
        XCTAssertEqual(view1?.renderedImage, imageData1)
    }

    // MARK: - Image Loading (Preloading)

    func test_itemImageView_preloadsImageURLWhenNearVisible() {
        let item0 = makeItem(category: .dog)
        let item1 = makeItem(category: .cat)

        let (sut, spy) = makeSUT()

        sut.loadViewIfNeeded()

        let feed = [item0, item1]
        spy.completeFeedLoading(with: .success(feed))

        XCTAssertTrue(spy.loadImageRequests.isEmpty)

        sut.simulateFeedItemNearVisible(at: 0)

        XCTAssertEqual(spy.loadImageRequests, [item0.imageURL])

        sut.simulateFeedItemNearVisible(at: 1)

        XCTAssertEqual(spy.loadImageRequests, [item0.imageURL, item1.imageURL])
    }

    func test_itemImageView_cancelsImageURLPreloadingWhenNotNearVisibleAnymore() {
        let item0 = makeItem(category: .dog)
        let item1 = makeItem(category: .cat)

        let (sut, spy) = makeSUT()

        sut.loadViewIfNeeded()

        let feed = [item0, item1]
        spy.completeFeedLoading(with: .success(feed))

        XCTAssertTrue(spy.cancelledRequests.isEmpty)

        sut.simulateFeedItemNoLongerNearVisible(at: 0)

        XCTAssertEqual(spy.cancelledRequests, [item0.imageURL])

        sut.simulateFeedItemNoLongerNearVisible(at: 1)

        XCTAssertEqual(spy.cancelledRequests, [item0.imageURL, item1.imageURL])
    }

    func test_itemImageView_doesNotRenderLoadedImageWhenNotVisibleAnymore() {
        let (sut, spy) = makeSUT()
        sut.loadViewIfNeeded()
        spy.completeFeedLoading(with: .success([makeItem(category: .dog)]))

        let view = sut.simulateFeedItemNotVisible(at: 0)
        spy.completeImageLoading(with: .success(UIImage.makeImageData(withColor: .red)))

        XCTAssertNil(view?.renderedImage)
    }

    func test_imageLoadCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, spy) = makeSUT()

        sut.loadViewIfNeeded()

        let feed = [makeItem(category: .dog)]
        spy.completeFeedLoading(with: .success(feed))

        _ = sut.simulateFeedItemVisible(at: 0)

        let exp = expectation(description: "await background queue")
        DispatchQueue.global().async {
            spy.completeImageLoading(with: .success(UIImage.makeImageData(withColor: .red)))
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    func test_itemImageView_doesNotLoadImageAgainUntilPreviousRequestCompletes() {
        let item0 = makeItem(category: .dog)
        let (sut, spy) = makeSUT()
        sut.loadViewIfNeeded()
        spy.completeFeedLoading(with: .success([item0]))

        sut.simulateFeedItemNearVisible(at: 0)
        XCTAssertEqual(spy.loadImageRequests, [item0.imageURL])

        sut.simulateFeedItemNearVisible(at: 0)
        XCTAssertEqual(spy.loadImageRequests, [item0.imageURL])

        let imageData0 = UIImage.makeImageData(withColor: .blue)
        spy.completeImageLoading(with: .success(imageData0))

        sut.simulateFeedItemNearVisible(at: 0)
        XCTAssertEqual(spy.loadImageRequests, [item0.imageURL, item0.imageURL])

        sut.simulateFeedItemNearVisible(at: 0)
        XCTAssertEqual(spy.loadImageRequests, [item0.imageURL, item0.imageURL])

        sut.simulateFeedItemNotVisible(at: 0)
        sut.simulateFeedItemNearVisible(at: 0)
        XCTAssertEqual(spy.loadImageRequests, [item0.imageURL, item0.imageURL, item0.imageURL])
    }

    // MARK: - Selection

    func test_item_notifiesHandlerOnSelection() {
        let item0 = makeItem(category: .dog)
        let item1 = makeItem(category: .cat)

        var output: [FeedItem] = []

        let (sut, spy) = makeSUT(selection: { output.append($0) })

        sut.loadViewIfNeeded()

        let feed = [item0, item1]
        spy.completeFeedLoading(with: .success(feed))

        XCTAssertTrue(output.isEmpty)

        sut.simulateFeedItemSelection(at: 0)

        XCTAssertEqual(output, [item0])

        sut.simulateFeedItemSelection(at: 1)

        XCTAssertEqual(output, [item0, item1])
    }
}

private extension FeedUIIntegrationTests {
    func makeSUT(file: StaticString = #filePath, line: UInt = #line, selection: @escaping (FeedItem) -> Void = { _ in }) -> (sut: CollectionViewController, spy: LoaderSpy) {
        let spy = LoaderSpy()
        let sut = FeedUIComposer.compose(loader: spy.load, imageLoader: spy.load(_:), selection: selection)

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
