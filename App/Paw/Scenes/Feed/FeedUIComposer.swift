//
//  FeedUIComposer.swift
//  Paw
//
//  Created by Gordon Smith on 02/09/2022.
//

import UIKit
import Combine

enum FeedUIComposer {
    
    typealias FeedLoader = () -> AnyPublisher<[FeedItem], Error>
    
    static func compose(loader: @escaping FeedLoader) -> CollectionViewController {
        
        let layout = makeCompositionalLayout()
        let controller = CollectionViewController(layout: layout)
        
        controller.configure = {
            $0.refreshControl = UIRefreshControl(frame: .zero)
            $0.register(PetGridViewCell.self)
        }
        
        let adapter = LoadResourcePresentationAdapter<[FeedItem], FeedViewAdapter>(loader: loader)
        adapter.presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(controller: controller),
            loadingView: WeakRefVirtualProxy(controller)
        )
        
        controller.onLoad = adapter.loadResource
        
        return controller
    }
}

private extension FeedUIComposer {
    static func makeCompositionalLayout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

