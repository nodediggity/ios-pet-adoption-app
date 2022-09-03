//
// PetDetailTagCell.swift
//

import UIKit

public final class PetDetailTagCell: UICollectionViewCell {
    public private(set) lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(hex: "dbd3ff")
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        button.setTitleColor(UIColor(hex: "928ab6"), for: .normal)
        button.contentEdgeInsets.left = 8
        button.contentEdgeInsets.right = 8
        button.layer.cornerRadius = 6

        contentView.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: button.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: button.trailingAnchor)
        ])

        return button
    }()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        nil
    }
}
