//
// UIView+Shadow.swift
//

import UIKit

public extension UIView {
    func addShadow(offset: CGSize = .init(width: 0, height: 4), color: UIColor = .init(red: 0.18, green: 0.18, blue: 0.18, alpha: 0.16), radius: CGFloat = 12, opacity: Float = 1) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity

        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
