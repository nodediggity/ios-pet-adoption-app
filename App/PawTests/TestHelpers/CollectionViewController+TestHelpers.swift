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
