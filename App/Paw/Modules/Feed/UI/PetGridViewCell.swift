//
//  PetGridViewCell.swift
//  Paw
//
//  Created by Gordon Smith on 02/09/2022.
//

import UIKit

public final class PetGridViewCell: UICollectionViewCell {
    
    private(set) public lazy var imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    private(set) public lazy var nameLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.textColor = .label
        view.font = .preferredFont(forTextStyle: .body, compatibleWith: .init(legibilityWeight: .bold))
        view.numberOfLines = 1
        return view
    }()
    
    private(set) public lazy var ageLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.textColor = .secondaryLabel
        view.font = .preferredFont(forTextStyle: .caption1)
        view.numberOfLines = 1
        return view
    }()
    
    private(set) public lazy var breedLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.textColor = .secondaryLabel
        view.font = .preferredFont(forTextStyle: .subheadline)
        view.numberOfLines = 2
        return view
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    public required init?(coder: NSCoder) {
        nil
    }
    
}

private extension PetGridViewCell {
    func configureUI() {
        
        contentView.backgroundColor = .secondarySystemBackground
        
        let hStack = UIStackView(arrangedSubviews: [
            nameLabel,
            ageLabel
        ])
        hStack.axis = .horizontal
        
        let vStack = UIStackView(arrangedSubviews: [
            hStack,
            breedLabel
        ])
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        vStack.isLayoutMarginsRelativeArrangement = true
        vStack.layoutMargins = .init(top: 4, left: 6, bottom: 4, right: 6)
        
        [imageView, vStack].forEach(contentView.addSubview)
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 130),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            
            vStack.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: vStack.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: vStack.trailingAnchor)
        ])
        
    }
}
