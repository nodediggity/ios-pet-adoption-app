//
//  UIView+LayoutCycle.swift
//  PawTests
//
//  Created by Gordon Smith on 02/09/2022.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
