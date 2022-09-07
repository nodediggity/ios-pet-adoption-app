//
// PetGridViewCell.swift
//

import UIKit

public final class PetGridViewCell: UICollectionViewCell {
    
    public var name: String? {
        didSet { setNeedsUpdateConfiguration() }
    }
    
    public var age: String? {
        didSet { setNeedsUpdateConfiguration() }
    }
    
    public var breed: String? {
        didSet { setNeedsUpdateConfiguration() }
    }
    
    public var image: UIImage? {
        didSet { setNeedsUpdateConfiguration() }
    }
    
    public override func updateConfiguration(using state: UICellConfigurationState) {
        var config = PetGridViewCellContentConfiguration().updated(for: state)
        
        config.name = name
        config.age = age
        config.breed = breed
        config.image = image
        contentConfiguration = config
    }
}
