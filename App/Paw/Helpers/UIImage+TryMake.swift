//
// UIImage+TryMake.swift
//

import UIKit

extension UIImage {
    struct InvalidImageData: Error { }

    static func tryMake(data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw InvalidImageData()
        }
        return image
    }
}
