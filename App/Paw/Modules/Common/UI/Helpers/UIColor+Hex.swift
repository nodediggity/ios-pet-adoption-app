//
//  UIColor+Hex.swift
//  Paw
//
//  Created by Gordon Smith on 02/09/2022.
//

import UIKit

public extension UIColor {
    convenience init(hex: String) {
        let hex = hex.replacingOccurrences(of: "#", with: "")
        guard let int = Scanner(string: hex).scanInt32(representation: .hexadecimal) else {
            self.init(red: 0, green: 0, blue: 0, alpha: 1)
            return
        }

        let a, r, g, b: Int32
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17) // RGB (12-bit)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF) // RGB (24-bit)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF) // ARGB (32-bit)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)
    }
}
