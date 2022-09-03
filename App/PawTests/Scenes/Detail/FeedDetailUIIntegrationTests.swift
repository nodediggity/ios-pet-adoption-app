//
// FeedDetailUIIntegrationTests.swift
//

import UIKit
import XCTest
@testable import Paw

class FeedDetailUIIntegrationTests: XCTestCase {
    // MARK: - Detail Loading

    func test_loadActions_requestFromLoader() {
        let (sut, spy) = makeSUT()

        XCTAssertEqual(spy.loadDetailsCallCount, 0)

        sut.loadViewIfNeeded()
        XCTAssertEqual(spy.loadDetailsCallCount, 1)

        spy.completeDetailsLoading(with: .failure(makeError()))

        sut.simulateUserInitiatedReload()
        XCTAssertEqual(spy.loadDetailsCallCount, 2)
    }

    func test_loadingIndicator_isVisibleWhileLoading() {
        let (sut, spy) = makeSUT()

        let error = makeError()

        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator)

        spy.completeDetailsLoading(with: .failure(error))
        XCTAssertFalse(sut.isShowingLoadingIndicator)

        sut.simulateUserInitiatedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator)

        spy.completeDetailsLoading(with: .failure(error), at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator)

        sut.simulateUserInitiatedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator)

        let details = makeProfile()
        spy.completeDetailsLoading(with: .success(details), at: 2)
        XCTAssertFalse(sut.isShowingLoadingIndicator)
    }

    func test_loadCompletion_rendersSuccessfully() {
        let (sut, spy) = makeSUT()

        sut.loadViewIfNeeded()

        let details = makeProfile(tagCount: 0, isAvailable: false)
        spy.completeDetailsLoading(with: .success(details))

        assertThat(sut, isRendering: details)

        sut.simulateUserInitiatedReload()

        let refreshedDetails = makeProfile(tagCount: 5, isAvailable: true)
        spy.completeDetailsLoading(with: .success(refreshedDetails), at: 1)

        assertThat(sut, isRendering: refreshedDetails)
    }

    func test_loadCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let (sut, spy) = makeSUT()

        sut.loadViewIfNeeded()

        let details = makeProfile()
        spy.completeDetailsLoading(with: .success(details))

        assertThat(sut, isRendering: details)

        sut.simulateUserInitiatedReload()

        let error = makeError()
        spy.completeDetailsLoading(with: .failure(error), at: 1)

        assertThat(sut, isRendering: details)
    }

    func test_loadCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, spy) = makeSUT()

        sut.loadViewIfNeeded()

        let details = makeProfile()
        let exp = expectation(description: "await background queue")
        DispatchQueue.global().async {
            spy.completeDetailsLoading(with: .success(details))
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    // MARK: - Image Loading

    func test_imageView_loadsImageURLWhenVisible() {
        let (sut, spy) = makeSUT()

        sut.loadViewIfNeeded()

        let details = makeProfile()
        spy.completeDetailsLoading(with: .success(details))

        XCTAssertTrue(spy.loadImageRequests.isEmpty)

        sut.simulateImageViewItemVisible(at: 0)

        XCTAssertEqual(spy.loadImageRequests, [details.imageURL])
    }

    func test_imageView_cancelsImageLoadingWhenNotVisibleAnymore() {
        let (sut, spy) = makeSUT()

        sut.loadViewIfNeeded()

        let details = makeProfile()
        spy.completeDetailsLoading(with: .success(details))

        XCTAssertTrue(spy.cancelledRequests.isEmpty)

        sut.simulateImageViewItemNotVisible(at: 0)

        XCTAssertEqual(spy.cancelledRequests, [details.imageURL])
    }

    func test_imageView_rendersImageLoadedFromURL() {
        let (sut, spy) = makeSUT()

        sut.loadViewIfNeeded()

        let details = makeProfile()
        spy.completeDetailsLoading(with: .success(details))

        let view = sut.simulateImageViewItemVisible(at: 0)

        XCTAssertNil(view?.renderedImage)

        let imageData = UIImage.makeImageData(withColor: .red)
        spy.completeImageLoading(with: .success(imageData))

        XCTAssertEqual(view?.renderedImage, imageData)
    }

    // MARK: - Image Loading (Preloading)

    func test_imageView_preloadsImageURLWhenNearVisible() {
        let (sut, spy) = makeSUT()

        sut.loadViewIfNeeded()

        let details = makeProfile()
        spy.completeDetailsLoading(with: .success(details))

        XCTAssertTrue(spy.loadImageRequests.isEmpty)

        sut.simulateImageViewItemNearVisible(at: 0)

        XCTAssertEqual(spy.loadImageRequests, [details.imageURL])
    }

    func test_imageView_cancelsImageURLPreloadingWhenNotNearVisibleAnymore() {
        let (sut, spy) = makeSUT()

        sut.loadViewIfNeeded()

        let details = makeProfile()
        spy.completeDetailsLoading(with: .success(details))

        XCTAssertTrue(spy.cancelledRequests.isEmpty)

        sut.simulateImageViewItemNoLongerNearVisible(at: 0)

        XCTAssertEqual(spy.cancelledRequests, [details.imageURL])
    }

    func test_imageView_doesNotRenderLoadedImageWhenNotVisibleAnymore() {
        let (sut, spy) = makeSUT()

        sut.loadViewIfNeeded()

        let details = makeProfile()
        spy.completeDetailsLoading(with: .success(details))

        let view = sut.simulateImageViewItemNotVisible(at: 0)
        spy.completeImageLoading(with: .success(UIImage.makeImageData(withColor: .red)))

        XCTAssertNil(view?.renderedImage)
    }

    func test_imageLoadCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, spy) = makeSUT()

        sut.loadViewIfNeeded()

        let details = makeProfile()
        spy.completeDetailsLoading(with: .success(details))

        _ = sut.simulateImageViewItemVisible(at: 0)

        let exp = expectation(description: "await background queue")
        DispatchQueue.global().async {
            spy.completeImageLoading(with: .success(UIImage.makeImageData(withColor: .red)))
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    func test_imageView_doesNotLoadImageAgainUntilPreviousRequestCompletes() {
        let (sut, spy) = makeSUT()

        sut.loadViewIfNeeded()

        let details = makeProfile()
        spy.completeDetailsLoading(with: .success(details))

        sut.simulateImageViewItemNearVisible(at: 0)
        XCTAssertEqual(spy.loadImageRequests, [details.imageURL])

        sut.simulateImageViewItemNearVisible(at: 0)
        XCTAssertEqual(spy.loadImageRequests, [details.imageURL])

        let imageData = UIImage.makeImageData(withColor: .blue)
        spy.completeImageLoading(with: .success(imageData))

        sut.simulateImageViewItemNearVisible(at: 0)
        XCTAssertEqual(spy.loadImageRequests, [details.imageURL, details.imageURL])

        sut.simulateImageViewItemNearVisible(at: 0)
        XCTAssertEqual(spy.loadImageRequests, [details.imageURL, details.imageURL])

        sut.simulateImageViewItemNotVisible(at: 0)
        sut.simulateImageViewItemNearVisible(at: 0)
        XCTAssertEqual(spy.loadImageRequests, [details.imageURL, details.imageURL, details.imageURL])
    }
}

private extension FeedDetailUIIntegrationTests {
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: CollectionViewController, spy: LoaderSpy) {
        let spy = LoaderSpy()
        let sut = FeedDetailUIComposer.compose(loader: spy.load, imageLoader: spy.load(_:))

        trackForMemoryLeaks(spy, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, spy)
    }

    func makeProfile(id: UUID = UUID(), tagCount: Int = 0, isAvailable: Bool = true) -> Profile {
        Profile(
            id: id,
            name: "any name \(id.uuidString)",
            tags: (0 ..< tagCount).map { "Tag #\($0)" },
            about: "any bio \(id.uuidString)",
            lastUpdatedDate: Date(),
            imageURL: makeURL(addr: "https://image.com/\(id.uuidString)"),
            isAvailable: isAvailable
        )
    }
}
