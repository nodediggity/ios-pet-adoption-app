//
//  FeedDetailUIComposer.swift
//  Paw
//
//  Created by Gordon Smith on 02/09/2022.
//

import UIKit
import Combine

enum FeedDetailUIComposer {
    
    typealias ProfileLoader = () -> AnyPublisher<Profile, Error>
    typealias ImageLoader = (URL) -> AnyPublisher<Data, Error>
    
    static func compose(loader: @escaping ProfileLoader, imageLoader: @escaping ImageLoader) -> CollectionViewController {
        
        let controller = CollectionViewController(layout: makeLayout)
        
        controller.configure = {
            $0.refreshControl = UIRefreshControl(frame: .zero)
            $0.register(PetDetailImageViewCell.self)
            $0.register(PetDetailViewBodyCell.self)
            $0.register(PetDetailViewBookCell.self)
            $0.register(PetDetailTagCell.self)
        }
            
        let adapter = LoadResourcePresentationAdapter<Profile, FeedDetailViewAdapter>(loader: loader)
        adapter.presenter = LoadResourcePresenter(
            resourceView: FeedDetailViewAdapter(
                controller: controller,
                imageLoader: imageLoader
            ),
            loadingView: WeakRefVirtualProxy(controller),
            mapper: { ProfilePresenter.map($0) }
        )
        
        controller.onLoad = adapter.loadResource
        
        return controller
    }
}

private extension FeedDetailUIComposer {
    
    static func makeLayout(for dataSource: CollectionViewController.DataSource) -> UICollectionViewLayout {
        { [weak dataSource] in
            
            let layout = UICollectionViewCompositionalLayout { index, env in
                let snapshot = dataSource?.snapshot()
                guard let section = snapshot?.sectionIdentifiers[index] else { return .none }

                var layoutSection: NSCollectionLayoutSection?

                switch section.category {
                    
                case .list:
                    
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                    let section = NSCollectionLayoutSection(group: group)
                    section.interGroupSpacing = 16
                    section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
                    
                    layoutSection = section
                    
                case .tags:
                    
                    let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .absolute(28))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: itemSize.heightDimension)
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                    group.interItemSpacing = .fixed(6)
                    
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
                    section.interGroupSpacing = 8
                    
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
