//
//  PetDetailViewBookActionCellController.swift
//  Paw
//
//  Created by Gordon Smith on 02/09/2022.
//

import UIKit

public final class PetDetailViewBookActionCellController: NSObject {
    private let viewModel: String
    private let selection: () -> Void
    
    init(viewModel: String, selection: @escaping () -> Void) {
        self.viewModel = viewModel
        self.selection = selection
    }
}

extension PetDetailViewBookActionCellController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PetDetailViewBookCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.button.setTitle(viewModel, for: .normal)
        return cell
    }
}
