//
//  PetGridViewCell+TestHelpers.swift
//  PawTests
//
//  Created by Gordon Smith on 02/09/2022.
//

import UIKit
import Paw

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
