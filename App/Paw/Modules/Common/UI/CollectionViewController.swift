//
// CollectionViewController.swift
//

import UIKit

public final class CollectionViewController: UICollectionViewController {
    public typealias DataSource = UICollectionViewDiffableDataSource<SectionController, CellController>

    public var configure: ((UICollectionView) -> Void)?

    public var onLoad: (() -> Void)?

    private var layout: ((DataSource) -> UICollectionViewLayout)?

    private lazy var dataSource: DataSource = {
        let ds = DataSource(collectionView: collectionView, cellProvider: { collectionView, index, controller -> UICollectionViewCell? in
            controller.dataSource.collectionView(collectionView, cellForItemAt: index)
        })
        return ds
    }()

    public init(layout: @escaping (DataSource) -> UICollectionViewLayout) {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        self.layout = layout
    }

    required init?(coder: NSCoder) {
        nil
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        load()
    }

    override public func traitCollectionDidChange(_ previous: UITraitCollection?) {
        if previous?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            collectionView.reloadData()
        }
    }

    override public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dl = controller(at: indexPath)?.delegate
        dl?.collectionView?(collectionView, didSelectItemAt: indexPath)
    }

    override public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let dl = controller(at: indexPath)?.delegate
        dl?.collectionView?(collectionView, willDisplay: cell, forItemAt: indexPath)
    }

    override public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let dl = controller(at: indexPath)?.delegate
        dl?.collectionView?(collectionView, didEndDisplaying: cell, forItemAt: indexPath)
    }

    override public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard collectionView.refreshControl?.isRefreshing == true else { return }
        load()
    }

    public func display(_ sections: [SectionController]) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionController, CellController>()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.controllers, toSection: section)
        }

        dataSource.apply(snapshot)
    }

    public func display(_ sections: SectionController...) {
        display(sections)
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
        collectionView.contentInset.bottom = 16

        collectionView.backgroundColor = .systemBackground

        if let layout = layout {
            collectionView.collectionViewLayout = layout(dataSource)
        }

        configure?(collectionView)
    }

    func controller(at indexPath: IndexPath) -> CellController? {
        dataSource.itemIdentifier(for: indexPath)
    }
}
