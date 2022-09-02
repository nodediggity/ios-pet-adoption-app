//
//  FeedViewAdapter.swift
//  Paw
//
//  Created by Gordon Smith on 02/09/2022.
//

import Foundation
import UIKit

final class FeedViewAdapter {
    typealias ImageLoader = FeedUIComposer.ImageLoader
    private weak var controller: CollectionViewController?
    
    private let imageLoader: ImageLoader
    
    init(controller: CollectionViewController, imageLoader: @escaping ImageLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
}

extension FeedViewAdapter: ResourceView {
    typealias ResourceViewModel = [FeedItem]
    func display(_ viewModel: ResourceViewModel) {
        guard let controller = controller else { return }
        
        let feed: [CellController] = viewModel.map { item in
            let viewModel = FeedItemPresenter.map(item)
            let view = PetGridViewCellController(viewModel: viewModel) { print("Tapped.") }
            
            let adapter = LoadResourcePresentationAdapter<Data, WeakRefVirtualProxy<PetGridViewCellController>>(loader: { [imageLoader] in imageLoader(item.imageURL) })
            adapter.presenter = LoadResourcePresenter(resourceView: WeakRefVirtualProxy(view), mapper: UIImage.tryMake(data:))
            
            view.onLoad = adapter.loadResource
            view.onCancel = adapter.cancel
            
            return CellController(id: item, view)
        }
        
        controller.display(feed)
    }
}
