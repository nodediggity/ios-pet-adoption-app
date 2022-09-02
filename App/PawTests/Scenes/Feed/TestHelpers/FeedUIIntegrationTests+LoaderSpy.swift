//
//  FeedUIIntegrationTests+LoaderSpy.swift
//  PawTests
//
//  Created by Gordon Smith on 02/09/2022.
//

import Foundation
import Paw
import Combine

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
    }
    
}
