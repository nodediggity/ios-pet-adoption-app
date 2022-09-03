//
// PetDetailBodyViewModel.swift
//

import Foundation

public struct PetDetailBodyViewModel: Equatable {
    public let name: String
    public let about: String
    public let updated: String
    public init(name: String, about: String, updated: String) {
        self.name = name
        self.about = about
        self.updated = updated
    }
}
