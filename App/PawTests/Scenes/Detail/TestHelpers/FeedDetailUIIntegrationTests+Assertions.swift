//
//  FeedDetailUIIntegrationTests+Assertions.swift
//  PawTests
//
//  Created by Gordon Smith on 03/09/2022.
//

import XCTest
import Paw

extension FeedDetailUIIntegrationTests {
    func assertThat(_ sut: CollectionViewController, isRendering profile: Profile, file: StaticString = #filePath, line: UInt = #line) {
        sut.view.enforceLayoutCycle()
        
        let layout = ProfilePresenter.map(profile)
        
        guard sut.numberOfSections == layout.count else {
            return XCTFail("Expected \(layout.count) items but got \(sut.numberOfRenderedItems()) instead.", file: file, line: line)
        }
                
        layout.enumerated().forEach { index, item in
            let indexPath = IndexPath(row: 0, section: index)
            switch item {
            case .image:
                assertThat(sut, hasImageViewConfiguredAt: indexPath, file: file, line: line)
            case let .tags(viewModel):
                assertThat(sut, hasTagsViewConfiguredFor: viewModel, at: indexPath, file: file, line: line)
            case let .body(viewModel):
                assertThat(sut, hasBodyViewConfiguredFor: viewModel, at: indexPath, file: file, line: line)
            case let .bookingAction(viewModel):
                assertThat(sut, hasBookingViewConfiguredFor: viewModel, at: indexPath, file: file, line: line)
            }
        }
        
        executeRunLoopToCleanUpReferences()
    }
}

private extension FeedDetailUIIntegrationTests {
    
    // Header Image
    func assertThat(_ sut: CollectionViewController, hasImageViewConfiguredAt indexPath: IndexPath, file: StaticString = #filePath, line: UInt = #line) {
        let cell = sut.cell(at: indexPath)
        let view = cell as? PetDetailImageViewCell
        
        XCTAssertNotNil(view, "Expected `PetDetailImageViewCell` for \(indexPath) but got \(type(of: cell)) instead", file: file, line: line)
    }
    
    // Body Text
    func assertThat(_ sut: CollectionViewController, hasBodyViewConfiguredFor viewModel: PetDetailBodyViewModel, at indexPath: IndexPath, file: StaticString = #filePath, line: UInt = #line) {
        let cell = sut.cell(at: indexPath)
        guard let view = cell as? PetDetailViewBodyCell else {
            return XCTFail("Expected `PetDetailViewBodyCell` for \(indexPath) but got \(type(of: cell)) instead", file: file, line: line)
        }
        
        XCTAssertEqual(view.nameText, viewModel.name, file: file, line: line)
        XCTAssertEqual(view.bodyText, viewModel.about, file: file, line: line)
        XCTAssertEqual(view.dateText, viewModel.updated, file: file, line: line)
    }
    
    // Tags
    func assertThat(_ sut: CollectionViewController, hasTagsViewConfiguredFor viewModel: [String], at indexPath: IndexPath, file: StaticString = #filePath, line: UInt = #line) {
        let itemCount = sut.numberOfRenderedItems(in: indexPath.section)
        guard itemCount == viewModel.count else {
            return XCTFail("Expected \(viewModel.count) items but got \(itemCount) instead.", file: file, line: line)
        }
        
        viewModel.enumerated().forEach { index, item in
            let cell = sut.cell(at: IndexPath(item: index, section: indexPath.section))
            if let view = cell as? PetDetailTagCell {
                XCTAssertEqual(view.text, item, file: file, line: line)
            } else {
                XCTFail("Expected `TagCloudCell` for \(index) but got \(type(of: cell)) instead", file: file, line: line)
            }
        }
    }
    
    // Booking Actions
    func assertThat(_ sut: CollectionViewController, hasBookingViewConfiguredFor viewModel: String, at indexPath: IndexPath, file: StaticString = #filePath, line: UInt = #line) {
        let cell = sut.cell(at: indexPath)
        guard let view = cell as? PetDetailViewBookCell else {
            return XCTFail("Expected `PetDetailViewBookCell` for \(indexPath) but got \(type(of: cell)) instead", file: file, line: line)
        }
        
        XCTAssertEqual(view.messageText, viewModel, file: file, line: line)
    }
    
    func executeRunLoopToCleanUpReferences() {
        RunLoop.current.run(until: Date())
    }
}
