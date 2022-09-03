//
//  PetDetailTagCellController.swift
//  Paw
//
//  Created by Gordon Smith on 03/09/2022.
//

import UIKit

public final class PetDetailTagCellController: NSObject {
    private var cell: PetDetailTagCell?
    private let viewModel: String

    public init(viewModel: String) {
        self.viewModel = viewModel
    }
}

extension PetDetailTagCellController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        cell = collectionView.dequeueReusableCell(for: indexPath)
        cell?.button.setTitle(viewModel, for: .normal)
        return cell!
    }
}
