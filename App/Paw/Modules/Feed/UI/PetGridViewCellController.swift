//
//  PetGridViewCellController.swift
//  Paw
//
//  Created by Gordon Smith on 02/09/2022.
//

import UIKit

public final class PetGridViewCellController: NSObject {
    
    public var onLoad: (() -> Void)?
    public var onCancel: (() -> Void)?
    
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
                
        onLoad?()
        
        return cell!
    }
}

extension PetGridViewCellController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selection()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cancelLoad()
    }
}

extension PetGridViewCellController: UICollectionViewDataSourcePrefetching {
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        onLoad?()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        cancelLoad()
    }
}

extension PetGridViewCellController: ResourceView {
    public typealias ResourceViewModel = UIImage
    public func display(_ viewModel: ResourceViewModel) {
        cell?.imageView.image = viewModel
    }
}

private extension PetGridViewCellController {
    func cancelLoad() {
        releaseCellForReuse()
        onCancel?()
    }
    
    func releaseCellForReuse() {
        cell = nil
    }
}
