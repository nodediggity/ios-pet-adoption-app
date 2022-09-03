//
// PetDetailImageViewCell.swift
//

import UIKit

public final class PetDetailImageViewCell: UICollectionViewCell {
    public private(set) lazy var imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()

    override public init(frame: CGRect) {
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
