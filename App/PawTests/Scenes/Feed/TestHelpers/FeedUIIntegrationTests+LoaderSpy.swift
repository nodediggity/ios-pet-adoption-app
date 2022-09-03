//
// FeedUIIntegrationTests+LoaderSpy.swift
//

import Combine
import Foundation
import Paw

extension FeedUIIntegrationTests {
    class LoaderSpy {
        var loadFeedCallCount: Int { loadFeedRequests.count }

        private var loadFeedRequests: [PassthroughSubject<[FeedItem], Error>] = []

        func load() -> AnyPublisher<[FeedItem], Error> {
            let publisher = PassthroughSubject<[FeedItem], Error>()
            loadFeedRequests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }

        func completeFeedLoading(with result: Result<[FeedItem], Error>, at index: Int = 0) {
            switch result {
            case let .success(items):
                loadFeedRequests[index].send(items)
            case let .failure(error):
                loadFeedRequests[index].send(completion: .failure(error))
            }
            loadFeedRequests[index].send(completion: .finished)
        }

        var loadImageRequests: [URL] { imageRequestCache.map(\.url) }
        private(set) var cancelledRequests: [URL] = []

        private var imageRequestCache: [(url: URL, publisher: PassthroughSubject<Data, Error>)] = []

        func load(_ imageURL: URL) -> AnyPublisher<Data, Error> {
            let publisher = PassthroughSubject<Data, Error>()
            imageRequestCache.append((imageURL, publisher))
            return publisher
                .handleEvents(receiveCancel: { [weak self] in self?.cancelledRequests.append(imageURL) })
                .eraseToAnyPublisher()
        }

        func completeImageLoading(with result: Result<Data, Error>, at index: Int = 0) {
            switch result {
            case let .success(items):
                imageRequestCache[index].publisher.send(items)
            case let .failure(error):
                imageRequestCache[index].publisher.send(completion: .failure(error))
            }
            imageRequestCache[index].publisher.send(completion: .finished)
        }
    }
}
