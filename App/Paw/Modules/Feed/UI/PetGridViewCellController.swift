//
// PetGridViewCellController.swift
//

import UIKit

public final class PetGridViewCellController: NSObject {
    public var onLoad: (() -> Void)?
    public var onCancel: (() -> Void)?
    public var onChange: (() -> Void)?

    private let viewModel: FeedItemViewModel
    private var image: UIImage?
    private let selection: () -> Void
    
    private let registration = UICollectionView.CellRegistration<PetGridViewCell, PetGridViewCellController> { cell, _, item in
        cell.name = item.viewModel.name
        cell.age = item.viewModel.age
        cell.breed = item.viewModel.breed
        cell.image = item.image
    }

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
        let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: self)
        onLoad?()
        return cell
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
        self.image = viewModel
        onChange?()
    }
}

private extension PetGridViewCellController {
    func cancelLoad() {
        onCancel?()
    }
}
