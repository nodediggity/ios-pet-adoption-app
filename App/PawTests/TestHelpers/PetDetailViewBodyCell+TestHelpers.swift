//
// PetDetailViewBodyCell+TestHelpers.swift
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
