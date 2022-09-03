//
// PostDetailImageViewCell+TestHelpers.swift
//

import Paw
import UIKit

extension PetDetailImageViewCell {
    var renderedImage: Data? {
        imageView.image?.pngData()
    }
}
