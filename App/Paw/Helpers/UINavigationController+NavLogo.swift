//
//  UINavigationController+NavLogo.swift
//  Paw
//
//  Created by Gordon Smith on 02/09/2022.
//

import UIKit

extension UINavigationController {
    func showLogo() {
        let customView = UIImageView(image: .init(named: "nav_logo")?.resized(to: CGSize(width: 69, height: 30)).withRenderingMode(.alwaysTemplate))
        customView.tintColor =  UIColor(hex: "F2968F")
        topViewController?.navigationItem.leftBarButtonItem = .init(customView: customView)
    }
}

