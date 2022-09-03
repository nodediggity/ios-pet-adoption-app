//
//  PetDetailImageViewCell.swift
//  Paw
//
//  Created by Gordon Smith on 02/09/2022.
//

import UIKit

public final class PetDetailImageViewCell: UICollectionViewCell {
    
    private(set) public lazy var imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
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

private extension PetDetailImageViewCell {
    func configureUI() {
        
        contentView.backgroundColor = .clear
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 284),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
        ])
        
    }
}
