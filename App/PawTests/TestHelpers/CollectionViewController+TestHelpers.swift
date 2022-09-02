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
    func simulateItemVisible(at index: Int) -> PetGridViewCell? {
        cell(at: IndexPath(item: index, section: homeFeedSection)) as? PetGridViewCell
    }
    
    @discardableResult
    func simulateItemNotVisible(at index: Int) -> PetGridViewCell? {
        let indexPath = IndexPath(row: index, section: homeFeedSection)
        let view = simulateItemVisible(at: index)
        
        let dl = collectionView.delegate
        dl?.collectionView?(collectionView, didEndDisplaying: view!, forItemAt: indexPath)

        return view
    }
    
    func simulateItemNearVisible(at index: Int) {
        let pds = collectionView.prefetchDataSource
        let indexPath = IndexPath(item: index, section: homeFeedSection)
        pds?.collectionView(collectionView, prefetchItemsAt: [indexPath])
    }
    
    func simulateItemNoLongerNearVisible(at index: Int) {
        simulateItemNearVisible(at: index)
        
        let pds = collectionView.prefetchDataSource
        let indexPath = IndexPath(item: index, section: homeFeedSection)
        pds?.collectionView?(collectionView, cancelPrefetchingForItemsAt: [indexPath])
    }
}
