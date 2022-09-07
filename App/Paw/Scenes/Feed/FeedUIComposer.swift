//
// FeedUIComposer.swift
//

import Combine
import UIKit

enum FeedUIComposer {
    typealias FeedLoader = () -> AnyPublisher<[FeedItem], Error>
    typealias ImageLoader = (URL) -> AnyPublisher<Data, Error>
    typealias SelectionHandler = (FeedItem) -> Void

    static func compose(loader: @escaping FeedLoader, imageLoader: @escaping ImageLoader, selection: @escaping SelectionHandler) -> CollectionViewController {
        let controller = CollectionViewController(layout: makeLayout)

        controller.configure = {
            $0.refreshControl = UIRefreshControl(frame: .zero)
        }

        let adapter = LoadResourcePresentationAdapter<[FeedItem], FeedViewAdapter>(loader: loader)
        adapter.presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(
                controller: controller,
                imageLoader: imageLoader,
                selection: selection
            ),
            loadingView: WeakRefVirtualProxy(controller)
        )

        controller.onLoad = adapter.loadResource

        return controller
    }
}

private extension FeedUIComposer {
    static func makeLayout(for dataSource: CollectionViewController.DataSource) -> UICollectionViewLayout {
        { [weak dataSource] in

            let layout = UICollectionViewCompositionalLayout { index, _ in
                let snapshot = dataSource?.snapshot()
                guard let section = snapshot?.sectionIdentifiers[index] else { return .none }

                var layoutSection: NSCollectionLayoutSection?

                switch section.category {
                case .grid:

                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)

                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
                    let spacing = CGFloat(10)
                    group.interItemSpacing = .fixed(spacing)

                    let section = NSCollectionLayoutSection(group: group)
                    section.interGroupSpacing = spacing
                    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

                    layoutSection = section

                default: break
                }

                return layoutSection
            }

            let config = UICollectionViewCompositionalLayoutConfiguration()
            layout.configuration = config
            return layout
        }()
    }
}
