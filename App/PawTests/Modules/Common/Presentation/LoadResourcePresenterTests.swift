//
//  LoadResourcePresenterTests.swift
//  PawTests
//
//  Created by Gordon Smith on 03/09/2022.
//

import XCTest
import Paw

class LoadResourcePresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty)
    }
    
    func test_didStartLoading_displaysNoErrorMessageAndStartsLoading() {
        let (sut, view) = makeSUT()
        
        sut.didStartLoading()
        
        XCTAssertEqual(view.messages, [
            .display(errorMessage: .none),
            .display(isLoading: true)
        ])
    }
    
    func test_didFinishLoadingResource_displaysResourceAndStopsLoading() {
        let (sut, view) = makeSUT(mapper: { resource in
            resource + " view model"
        })
        
        sut.didFinishLoading(with: "resource")
        
        XCTAssertEqual(view.messages, [
            .display(resourceViewModel: "resource view model"),
            .display(isLoading: false)
        ])
    }
    
    func test_didFinishLoadingWithMapperError_displaysErrorMessageAndStopsLoading() {
        let error = makeError(desc: "some error message")
        let (sut, view) = makeSUT(mapper: { resource in
            throw error
        })
        
        sut.didFinishLoading(with: "resource")
        
        XCTAssertEqual(view.messages, [
            .display(errorMessage: error.localizedDescription),
            .display(isLoading: false)
        ])
    }
    
    func test_didFinishLoadingWithError_displaysLocalizedErrorMessageAndStopsLoading() {
        let error = makeError(desc: "some error message")
        let (sut, view) = makeSUT()
        
        sut.didFinishLoading(with: error)
        
        XCTAssertEqual(view.messages, [
            .display(errorMessage: error.localizedDescription),
            .display(isLoading: false)
        ])
    }
    
    // MARK: - Helpers
    
    private typealias SUT = LoadResourcePresenter<String, ViewSpy>
    
    private func makeSUT(mapper: @escaping SUT.Mapper = { _ in "any" }, file: StaticString = #filePath, line: UInt = #line) -> (sut: SUT, view: ViewSpy) {
        let view = ViewSpy()
        let sut = SUT(resourceView: view, loadingView: view, errorView: view, mapper: mapper)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
    
    private class ViewSpy: ResourceView, ResourceLoadingView, ResourceErrorView {
        typealias ResourceViewModel = String
        
        enum Message: Hashable {
            case display(errorMessage: String?)
            case display(isLoading: Bool)
            case display(resourceViewModel: String)
        }
        
        private(set) var messages = Set<Message>()
        
        func display(_ viewModel: ResourceErrorViewModel) {
            messages.insert(.display(errorMessage: viewModel.message))
        }
        
        func display(_ viewModel: ResourceLoadingViewModel) {
            messages.insert(.display(isLoading: viewModel.isLoading))
        }
        
        func display(_ viewModel: String) {
            messages.insert(.display(resourceViewModel: viewModel))
        }
    }
    
}
