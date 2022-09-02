//
//  CellController.swift
//  Paw
//
//  Created by Gordon Smith on 02/09/2022.
//

import UIKit

public struct CellController {
    public let id: AnyHashable
    public let dataSource: UICollectionViewDataSource
    public let delegate: UICollectionViewDelegateFlowLayout?
    public let dataSourcePrefetching: UICollectionViewDataSourcePrefetching?

    public init(id: AnyHashable = UUID(), _ dataSource: UICollectionViewDataSource) {
        self.id = id
        self.dataSource = dataSource
        delegate = dataSource as? UICollectionViewDelegateFlowLayout
        dataSourcePrefetching = dataSource as? UICollectionViewDataSourcePrefetching
    }
}

extension CellController: Equatable {
    public static func == (lhs: CellController, rhs: CellController) -> Bool {
        lhs.id == rhs.id
    }
}

extension CellController: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
