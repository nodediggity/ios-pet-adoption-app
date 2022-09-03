//
//  PetDetailViewBodyCellController.swift
//  Paw
//
//  Created by Gordon Smith on 02/09/2022.
//

import UIKit

public final class PetDetailViewBodyCellController: NSObject {
    private let viewModel: PetDetailBodyViewModel
    private var cell: PetDetailViewBodyCell?
    
    init(viewModel: PetDetailBodyViewModel) {
        self.viewModel = viewModel
    }
}

extension PetDetailViewBodyCellController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        cell = collectionView.dequeueReusableCell(for: indexPath)
        
        cell?.nameLabel.text = viewModel.name
        cell?.bodyLabel.text = viewModel.about
        cell?.dataLabel.text = viewModel.updated
        
        return cell!
    }
}
