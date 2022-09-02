//
//  CollectionViewController.swift
//  Paw
//
//  Created by Gordon Smith on 02/09/2022.
//

import UIKit

public final class CollectionViewController: UICollectionViewController {
    
    public typealias DataSource = UICollectionViewDiffableDataSource<Int, CellController>

    /// Provide additional configuration for the `UICollectionView` such as registering cells or setting preferences
    public var configure: ((UICollectionView) -> Void)?
    
    public var onLoad: (() -> Void)?

    private lazy var dataSource: DataSource = {
        let ds = DataSource(collectionView: collectionView, cellProvider: { collectionView, index, controller -> UICollectionViewCell? in
            controller.dataSource.collectionView(collectionView, cellForItemAt: index)
        })
        return ds
    }()

    public init(layout: UICollectionViewCompositionalLayout) {
        super.init(collectionViewLayout: layout)
    }

    required init?(coder: NSCoder) {
        nil
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        load()
    }
    
    public override func traitCollectionDidChange(_ previous: UITraitCollection?) {
        if previous?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            collectionView.reloadData()
        }
    }

    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dl = controller(at: indexPath)?.delegate
        dl?.collectionView?(collectionView, didSelectItemAt: indexPath)
    }

    public override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let dl = controller(at: indexPath)?.delegate
        dl?.collectionView?(collectionView, willDisplay: cell, forItemAt: indexPath)
    }

    public override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let dl = controller(at: indexPath)?.delegate
        dl?.collectionView?(collectionView, didEndDisplaying: cell, forItemAt: indexPath)
    }
    
    public override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard collectionView.refreshControl?.isRefreshing == true else { return }
        load()
    }

    public func display(_ sections: [CellController]...) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CellController>()
        sections.enumerated().forEach { section, cellControllers in
            snapshot.appendSections([section])
            snapshot.appendItems(cellControllers, toSection: section)
        }

        dataSource.apply(snapshot)
    }
}

extension CollectionViewController: UICollectionViewDataSourcePrefetching {
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let dsp = controller(at: indexPath)?.dataSourcePrefetching
            dsp?.collectionView(collectionView, prefetchItemsAt: [indexPath])
        }
    }

    public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let dsp = controller(at: indexPath)?.dataSourcePrefetching
            dsp?.collectionView?(collectionView, cancelPrefetchingForItemsAt: [indexPath])
        }
    }
}

extension CollectionViewController: ResourceLoadingView {
    public func display(_ viewModel: ResourceLoadingViewModel) {
        if viewModel.isLoading {
            collectionView.refreshControl?.beginRefreshing()
        } else {
            collectionView.refreshControl?.endRefreshing()
        }
    }
}

private extension CollectionViewController {
    func load() {
        onLoad?()
    }
    
    func configureUI() {
        collectionView.dataSource = dataSource
        collectionView.prefetchDataSource = self
        
        collectionView.refreshControl = UIRefreshControl(frame: .zero)
        collectionView.contentInset.bottom = 16
        
        collectionView.backgroundColor = .systemBackground
        
        configure?(collectionView)
    }

    func controller(at indexPath: IndexPath) -> CellController? {
        dataSource.itemIdentifier(for: indexPath)
    }
}
