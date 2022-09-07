//
//  PetGridViewCellContentView.swift
//  Paw
//
//  Created by Gordon Smith on 07/09/2022.
//

import UIKit

public final class PetGridViewCellContentView: UIView, UIContentView {
    
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
    
    public var configuration: UIContentConfiguration {
        get { customConfiguration }
        set {
            guard let configuration = newValue as? PetGridViewCellContentConfiguration else { return }
            apply(configuration)
        }
    }
    
    private var customConfiguration: PetGridViewCellContentConfiguration
    
    public init(configuration: PetGridViewCellContentConfiguration) {
        self.customConfiguration = configuration
        super.init(frame: .zero)
        apply(configuration)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
}

private extension PetGridViewCellContentView {
    func apply(_ configuration: PetGridViewCellContentConfiguration) {
        nameLabel.text = configuration.name
        ageLabel.text = configuration.age
        breedLabel.text = configuration.breed
        imageView.image = configuration.image
    }
    
    func configureUI() {
        backgroundColor = .clear

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

        addSubview(container)

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

            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomAnchor.constraint(equalTo: container.bottomAnchor),
            trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
    }
}
