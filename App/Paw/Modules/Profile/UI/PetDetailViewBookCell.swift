//
// PetDetailViewBookCell.swift
//

import UIKit

public final class PetDetailViewBookCell: UICollectionViewCell {
    public private(set) lazy var button: UIButton = {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "F2968F")
        view.titleLabel?.font = .preferredFont(forTextStyle: .body, compatibleWith: .init(legibilityWeight: .bold))
        view.tintColor = .white
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

private extension PetDetailViewBookCell {
    func configureUI() {
        contentView.backgroundColor = .clear
        contentView.addSubview(button)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])

        let buttonBottomAnchor = contentView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 16)
        buttonBottomAnchor.priority = .defaultLow
        buttonBottomAnchor.isActive = true
    }
}
