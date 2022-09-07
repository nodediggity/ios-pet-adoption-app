//
//  PetGridViewCellContentConfiguration.swift
//  Paw
//
//  Created by Gordon Smith on 07/09/2022.
//

import UIKit

public struct PetGridViewCellContentConfiguration: UIContentConfiguration {
    
    public var name: String?
    public var age: String?
    public var breed: String?
    public var image: UIImage?
    
    public func makeContentView() -> UIView & UIContentView {
        PetGridViewCellContentView(configuration: self)
    }
    
    public func updated(for state: UIConfigurationState) -> PetGridViewCellContentConfiguration {
        self
    }
}
