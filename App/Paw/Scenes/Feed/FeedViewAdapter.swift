//
//  FeedViewAdapter.swift
//  Paw
//
//  Created by Gordon Smith on 02/09/2022.
//

import Foundation

final class FeedViewAdapter {
    private weak var controller: CollectionViewController?
    
    init(controller: CollectionViewController) {
        self.controller = controller
    }
}

extension FeedViewAdapter: ResourceView {
    typealias ResourceViewModel = [FeedItem]
    func display(_ viewModel: ResourceViewModel) {
        guard let controller = controller else { return }
        
        let feed: [CellController] = viewModel.map { item in
            let viewModel = FeedItemPresenter.map(item)
            let view = PetGridViewCellController(viewModel: viewModel) { print("Tapped.") }
            return CellController(id: item, view)
        }
        
        controller.display(feed)
    }
}
