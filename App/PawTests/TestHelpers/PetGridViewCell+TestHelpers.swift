//
// PetGridViewCell+TestHelpers.swift
//

import Paw
import UIKit

extension PetGridViewCell {
    var nameText: String? {
        nameLabel.text
    }

    var ageText: String? {
        ageLabel.text
    }

    var breedText: String? {
        breedLabel.text
    }

    var renderedImage: Data? {
        imageView.image?.pngData()
    }
}
