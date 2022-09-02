//
//  UIImage+Resize.swift
//  Paw
//
//  Created by Gordon Smith on 02/09/2022.
//

import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
