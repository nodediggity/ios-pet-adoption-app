//
// PetGridViewCell+TestHelpers.swift
//

import Paw
import UIKit

extension PetGridViewCell {
    var nameText: String? {
        name
    }

    var ageText: String? {
        age
    }

    var breedText: String? {
        breed
    }

    var renderedImage: Data? {
        image?.pngData()
    }
}
