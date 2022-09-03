//
// UICollectionView+Dequeueing.swift
//

import UIKit

public extension UICollectionView {
    /// Registers a class for use in creating new collection view cells.
    func register<T: UICollectionViewCell>(_ name: T.Type) {
        register(T.self, forCellWithReuseIdentifier: String(describing: name))
    }

    /// Returns a reusable collection view cell object located by its identifier.
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
    }

    /// Registers a class for use in creating new header view.
    func registerSectionHeader<T: UICollectionReusableView>(_ name: T.Type) {
        let identifier = String(describing: T.self)
        register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
    }

    /// Returns a reusable header view located by its identifier.
    func dequeueSupplementaryHeaderView<T: UICollectionReusableView>(for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier, for: indexPath) as! T
    }
}
