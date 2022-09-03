//
//  FeedDetailViewAdapter.swift
//  Paw
//
//  Created by Gordon Smith on 02/09/2022.
//

import UIKit

final class FeedDetailViewAdapter {
    typealias ImageLoader = FeedUIComposer.ImageLoader
    typealias ImageLoaderPresentationAdapter = LoadResourcePresentationAdapter<Data, WeakRefVirtualProxy<PetDetailImageViewCellController>>
    private weak var controller: CollectionViewController?
    
    private let imageLoader: ImageLoader
    
    init(controller: CollectionViewController, imageLoader: @escaping ImageLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
}

extension FeedDetailViewAdapter: ResourceView {
    typealias ResourceViewModel = [ProfileComponent]
    func display(_ viewModel: ResourceViewModel) {
        guard let controller = controller else { return }
        
        var sections: [SectionController] = []
        
        viewModel.forEach { component in
            switch component {
            case let .image(imageURL):
                
                let view = PetDetailImageViewCellController()
                
                let adapter = ImageLoaderPresentationAdapter(loader: { [imageLoader] in
                    imageLoader(imageURL)
                })
                
                adapter.presenter = LoadResourcePresenter(resourceView: WeakRefVirtualProxy(view), mapper: UIImage.tryMake(data:))
                
                view.onLoad = adapter.loadResource
                view.onCancel = adapter.cancel
                
                let controller = CellController(id: UUID(), view)
                sections.append(.init(category: .list, controllers: [controller]))
                
            case let .body(bodyViewModel):

                let view = PetDetailViewBodyCellController(viewModel: bodyViewModel)
                let controller = CellController(id: UUID(), view)
                sections.append(.init(category: .list, controllers: [controller]))

            case let .tags(tagsViewModel):
                
                sections.append(.init(category: .tags, controllers: tagsViewModel.map { tag in
                    let view = PetDetailTagCellController(viewModel: tag)
                    return CellController(id: UUID(), view)
                }))

            case let .bookingAction(bookingViewModel):
                
                let view = PetDetailViewBookActionCellController(viewModel: bookingViewModel, selection: { /* Do Nothing... */ })
                let controller = CellController(id: UUID(), view)
                sections.append(.init(category: .list, controllers: [controller]))
            }
        }

        controller.display(sections)
    }
}
