//
//  PostDetailImageViewCell+TestHelpers.swift
//  PawTests
//
//  Created by Gordon Smith on 03/09/2022.
//

import UIKit
import Paw

extension PetDetailImageViewCell {
    var renderedImage: Data? {
        imageView.image?.pngData()
    }
}
