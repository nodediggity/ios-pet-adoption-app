//
//  FeedViewController.swift
//  Paw
//
//  Created by Gordon Smith on 01/09/2022.
//

import UIKit

public final class FeedViewController: UICollectionViewController {
    public typealias LoaderResult = Result<[FeedItem], Error>
    public typealias LoaderCompletion = (LoaderResult) -> Void
    public typealias Loader = (@escaping LoaderCompletion) -> Void
    
    private let loader: Loader
    
    private let refreshControl = UIRefreshControl(frame: .zero)
    
    public init(loader: @escaping Loader) {
        self.loader = loader
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.refreshControl = refreshControl
        
        load()
    }
    
    public override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard refreshControl.isRefreshing else { return }
        load()
    }
}

private extension FeedViewController {
    func load() {
        refreshControl.beginRefreshing()
        loader { [weak self] _ in
            self?.refreshControl.endRefreshing()
        }
    }
}
