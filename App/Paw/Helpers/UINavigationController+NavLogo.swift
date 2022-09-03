//
// UINavigationController+NavLogo.swift
//

import UIKit

extension UINavigationController {
    func configureLogo() {
        let customView = UIImageView(image: .init(named: "nav_logo")?.resized(to: CGSize(width: 69, height: 30)).withRenderingMode(.alwaysTemplate))
        customView.tintColor = UIColor(hex: "F2968F")
        topViewController?.navigationItem.leftBarButtonItem = .init(customView: customView)
        configureNotificationIcon()
    }

    private func configureNotificationIcon() {
        let customView = UIImageView(image: .init(named: "search")?.resized(to: CGSize(width: 28, height: 28)).withRenderingMode(.alwaysTemplate))
        customView.tintColor = .lightGray
        topViewController?.navigationItem.rightBarButtonItem = .init(customView: customView)
    }
}
