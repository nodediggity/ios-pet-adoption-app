//
//  PetGridViewCellController.swift
//  Paw
//
//  Created by Gordon Smith on 02/09/2022.
//

import UIKit

public final class PetGridViewCellController: NSObject {
    
    private let viewModel: FeedItemViewModel
    private let selection: () -> Void
    
    private var cell: PetGridViewCell?
    
    init(viewModel: FeedItemViewModel, selection: @escaping () -> Void) {
        self.viewModel = viewModel
        self.selection = selection
    }
}

extension PetGridViewCellController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        cell = collectionView.dequeueReusableCell(for: indexPath)
        
        cell?.nameLabel.text = viewModel.name
        cell?.breedLabel.text = viewModel.breed
        cell?.ageLabel.text = viewModel.age
        cell?.imageView.image = nil
                
        return cell!
    }
}

extension PetGridViewCellController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selection()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cancelLoad()
    }
}

extension PetGridViewCellController: UICollectionViewDataSourcePrefetching {
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        cancelLoad()
    }
}

private extension PetGridViewCellController {
    func cancelLoad() {
        releaseCellForReuse()
    }
    
    func releaseCellForReuse() {
        cell = nil
    }
}
