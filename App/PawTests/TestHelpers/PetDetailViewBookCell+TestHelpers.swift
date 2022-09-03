//
//  PetDetailViewBookCell+TestHelpers.swift
//  PawTests
//
//  Created by Gordon Smith on 03/09/2022.
//

import Foundation
import Paw

extension PetDetailViewBookCell {
    var messageText: String? {
        button.currentTitle
    }
}
