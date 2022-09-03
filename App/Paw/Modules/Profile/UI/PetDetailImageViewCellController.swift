//
// PetDetailImageViewCellController.swift
//

import UIKit

public final class PetDetailImageViewCellController: NSObject {
    public var onLoad: (() -> Void)?
    public var onCancel: (() -> Void)?

    private var cell: PetDetailImageViewCell?
}

extension PetDetailImageViewCellController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        cell = collectionView.dequeueReusableCell(for: indexPath)

        cell?.imageView.image = nil

        onLoad?()

        return cell!
    }
}

extension PetDetailImageViewCellController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cancelLoad()
    }
}

extension PetDetailImageViewCellController: UICollectionViewDataSourcePrefetching {
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        onLoad?()
    }

    public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        cancelLoad()
    }
}

extension PetDetailImageViewCellController: ResourceView {
    public typealias ResourceViewModel = UIImage
    public func display(_ viewModel: ResourceViewModel) {
        cell?.imageView.image = viewModel
    }
}

private extension PetDetailImageViewCellController {
    func cancelLoad() {
        releaseCellForReuse()
        onCancel?()
    }

    func releaseCellForReuse() {
        cell = nil
    }
}
