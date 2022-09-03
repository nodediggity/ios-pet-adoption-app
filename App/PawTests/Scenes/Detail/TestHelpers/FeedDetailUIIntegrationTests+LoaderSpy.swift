//
// FeedDetailUIIntegrationTests+LoaderSpy.swift
//

import Combine
import Foundation
import Paw

extension FeedDetailUIIntegrationTests {
    class LoaderSpy {
        var loadDetailsCallCount: Int { loadDetailsRequests.count }

        private var loadDetailsRequests: [PassthroughSubject<Profile, Error>] = []

        func load() -> AnyPublisher<Profile, Error> {
            let publisher = PassthroughSubject<Profile, Error>()
            loadDetailsRequests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }

        func completeDetailsLoading(with result: Result<Profile, Error>, at index: Int = 0) {
            switch result {
            case let .success(items):
                loadDetailsRequests[index].send(items)
            case let .failure(error):
                loadDetailsRequests[index].send(completion: .failure(error))
            }
            loadDetailsRequests[index].send(completion: .finished)
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
