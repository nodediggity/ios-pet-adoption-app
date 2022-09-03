//
//  PetDetailViewBodyCell+TestHelpers.swift
//  PawTests
//
//  Created by Gordon Smith on 03/09/2022.
//

import Foundation
import Paw

extension PetDetailViewBodyCell {
    var nameText: String? {
        nameLabel.text
    }
    
    var bodyText: String? {
        bodyLabel.text
    }
    
    var dateText: String? {
        dataLabel.text
    }
}

