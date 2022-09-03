//
// PetGridViewCell.swift
//

import UIKit

public final class PetGridViewCell: UICollectionViewCell {
    public private(set) lazy var imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()

    public private(set) lazy var nameLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.textColor = .label
        view.font = .preferredFont(forTextStyle: .body, compatibleWith: .init(legibilityWeight: .bold))
        view.numberOfLines = 1
        view.textAlignment = .left
        return view
    }()

    public private(set) lazy var ageLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.textColor = .secondaryLabel
        view.font = .preferredFont(forTextStyle: .caption1)
        view.numberOfLines = 1
        view.textAlignment = .right
        return view
    }()

    public private(set) lazy var breedLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.textColor = .secondaryLabel
        view.font = .preferredFont(forTextStyle: .subheadline)
        view.numberOfLines = 2
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

private extension PetGridViewCell {
    func configureUI() {
        contentView.backgroundColor = .clear

        let hStack = UIStackView(arrangedSubviews: [
            nameLabel,
            ageLabel
        ])
        hStack.axis = .horizontal
        hStack.distribution = .fillEqually

        let vStack = UIStackView(arrangedSubviews: [
            hStack,
            breedLabel
        ])
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        vStack.isLayoutMarginsRelativeArrangement = true
        vStack.layoutMargins = .init(top: 4, left: 6, bottom: 4, right: 6)

        let container = CardContainerView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .secondarySystemBackground

        contentView.addSubview(container)

        [imageView, vStack].forEach(container.addSubview)
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 130),
            imageView.topAnchor.constraint(equalTo: container.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),

            vStack.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            vStack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            container.bottomAnchor.constraint(equalTo: vStack.bottomAnchor),
            container.trailingAnchor.constraint(equalTo: vStack.trailingAnchor),

            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
    }
}
