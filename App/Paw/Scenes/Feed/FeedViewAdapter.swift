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
    typealias ImageLoaderPresentationAdapter = LoadResourcePresentationAdapter<Data, WeakRefVirtualProxy<PetGridViewCellController>>
    private weak var controller: CollectionViewController?
    
    private let imageLoader: ImageLoader
    private let selection: FeedUIComposer.SelectionHandler
    
    init(controller: CollectionViewController, imageLoader: @escaping ImageLoader, selection: @escaping FeedUIComposer.SelectionHandler) {
        self.controller = controller
        self.imageLoader = imageLoader
        self.selection = selection
    }
}

extension FeedViewAdapter: ResourceView {
    typealias ResourceViewModel = [FeedItem]
    func display(_ viewModel: ResourceViewModel) {
        guard let controller = controller else { return }
        
        let feed: [CellController] = viewModel.map { item in
            let viewModel = FeedItemPresenter.map(item)
            let view = PetGridViewCellController(viewModel: viewModel) { [selection] in selection(item) }
            
            let adapter = ImageLoaderPresentationAdapter(loader: { [imageLoader] in
                imageLoader(item.imageURL)
            })
            
            adapter.presenter = LoadResourcePresenter(resourceView: WeakRefVirtualProxy(view), mapper: UIImage.tryMake(data:))
            
            view.onLoad = adapter.loadResource
            view.onCancel = adapter.cancel
            
            return CellController(id: item, view)
        }
        
        controller.display(feed)
    }
}
