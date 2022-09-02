//
//  Tabs.swift
//  Paw
//
//  Created by Gordon Smith on 02/09/2022.
//

import UIKit

enum Tabs: CaseIterable {
    case feed
    case search
    case profile

    var iconOn: UIImage? {
        switch self {
        case .feed: return imageNamed("house")
        case .search: return imageNamed("search")
        case .profile: return imageNamed("user")
        }
    }

    var iconOff: UIImage? {
        switch self {
        case .feed: return imageNamed("house")
        case .search: return imageNamed("search")
        case .profile:return imageNamed("user")
        }
    }
    
    private func imageNamed(_ name: String) -> UIImage? {
        return UIImage(named: name)?.resized(to: CGSize(width: 28, height: 28)).withRenderingMode(.alwaysTemplate)
    }
}
