//
// Tabs.swift
//

import UIKit

enum Tabs: CaseIterable {
    case feed
    case alerts
    case profile

    var iconOn: UIImage? {
        switch self {
        case .feed: return imageNamed("house")
        case .alerts: return imageNamed("notification")
        case .profile: return imageNamed("user")
        }
    }

    var iconOff: UIImage? {
        switch self {
        case .feed: return imageNamed("house")
        case .alerts: return imageNamed("notification")
        case .profile: return imageNamed("user")
        }
    }

    private func imageNamed(_ name: String) -> UIImage? {
        UIImage(named: name)?.resized(to: CGSize(width: 28, height: 28)).withRenderingMode(.alwaysTemplate)
    }
}
