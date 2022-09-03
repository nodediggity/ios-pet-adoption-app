//
//  CollectionViewController+TestHelpers.swift
//  PawTests
//
//  Created by Gordon Smith on 02/09/2022.
//

import UIKit
import Paw

extension CollectionViewController {
    func simulateUserInitiatedReload() {
        collectionView.refreshControl?.beginRefreshing()
        scrollViewDidEndDragging(collectionView, willDecelerate: false)
    }
    
    var isShowingLoadingIndicator: Bool {
        collectionView.refreshControl?.isRefreshing == true
    }
    
    var numberOfSections: Int {
        guard collectionView.numberOfSections > 0 else { return 0 }
        return collectionView.numberOfSections
    }
    
    func numberOfRenderedItems(in section: Int = 0) -> Int {
        guard collectionView.numberOfSections > section else { return 0 }
        return collectionView.numberOfItems(inSection: section)
    }
    
    func cell(at indexPath: IndexPath) -> UICollectionViewCell? {
        guard collectionView.numberOfSections > indexPath.section else { return nil }
        let ds = collectionView.dataSource
        return ds?.collectionView(collectionView, cellForItemAt: indexPath)
    }
}

extension CollectionViewController {
    
    private var homeFeedSection: Int { 0 }
    
    @discardableResult
    func simulateFeedItemVisible(at index: Int) -> PetGridViewCell? {
        cell(at: IndexPath(item: index, section: homeFeedSection)) as? PetGridViewCell
    }
    
    @discardableResult
    func simulateFeedItemNotVisible(at index: Int) -> PetGridViewCell? {
        let indexPath = IndexPath(row: index, section: homeFeedSection)
        let view = simulateFeedItemVisible(at: index)
        
        let dl = collectionView.delegate
        dl?.collectionView?(collectionView, didEndDisplaying: view!, forItemAt: indexPath)

        return view
    }
    
    func simulateFeedItemNearVisible(at index: Int) {
        let pds = collectionView.prefetchDataSource
        let indexPath = IndexPath(item: index, section: homeFeedSection)
        pds?.collectionView(collectionView, prefetchItemsAt: [indexPath])
    }
    
    func simulateFeedItemNoLongerNearVisible(at index: Int) {
        simulateFeedItemNearVisible(at: index)
        
        let pds = collectionView.prefetchDataSource
        let indexPath = IndexPath(item: index, section: homeFeedSection)
        pds?.collectionView?(collectionView, cancelPrefetchingForItemsAt: [indexPath])
    }
    
    func simulateFeedItemSelection(at index: Int) {
        let dl = collectionView.delegate
        let indexPath = IndexPath(item: index, section: homeFeedSection)
        dl?.collectionView?(collectionView, didSelectItemAt: indexPath)
    }
}

extension CollectionViewController {
    
    private var profileDetailSection: Int { 0 }
    
    @discardableResult
    func simulateImageViewItemVisible(at index: Int) -> PetDetailImageViewCell? {
        cell(at: IndexPath(item: index, section: profileDetailSection)) as? PetDetailImageViewCell
    }
    
    @discardableResult
    func simulateImageViewItemNotVisible(at index: Int) -> PetDetailImageViewCell? {
        let indexPath = IndexPath(row: index, section: profileDetailSection)
        let view = simulateImageViewItemVisible(at: index)

        let dl = collectionView.delegate
        dl?.collectionView?(collectionView, didEndDisplaying: view!, forItemAt: indexPath)

        return view
    }

    func simulateImageViewItemNearVisible(at index: Int) {
        let pds = collectionView.prefetchDataSource
        let indexPath = IndexPath(item: index, section: profileDetailSection)
        pds?.collectionView(collectionView, prefetchItemsAt: [indexPath])
    }

    func simulateImageViewItemNoLongerNearVisible(at index: Int) {
        simulateImageViewItemNearVisible(at: index)

        let pds = collectionView.prefetchDataSource
        let indexPath = IndexPath(item: index, section: profileDetailSection)
        pds?.collectionView?(collectionView, cancelPrefetchingForItemsAt: [indexPath])
    }
}
