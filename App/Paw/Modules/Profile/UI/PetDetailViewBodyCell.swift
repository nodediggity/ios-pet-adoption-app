//
//  PetDetailViewBodyCell.swift
//  Paw
//
//  Created by Gordon Smith on 02/09/2022.
//

import UIKit

public final class PetDetailViewBodyCell: UICollectionViewCell {
    
    private(set) public lazy var nameLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.textColor = .label
        view.font = .preferredFont(forTextStyle: .title3, compatibleWith: .init(legibilityWeight: .bold))
        view.numberOfLines = 1
        return view
    }()
    
    private(set) public lazy var bodyLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.textColor = .secondaryLabel
        view.font = .preferredFont(forTextStyle: .body)
        view.numberOfLines = 0
        return view
    }()
    
    private(set) public lazy var dataLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.textColor = .secondaryLabel
        view.font = .preferredFont(forTextStyle: .caption1)
        view.numberOfLines = 1
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

private extension PetDetailViewBodyCell {
    func configureUI() {
        
        contentView.backgroundColor = .clear
        
        let vStack = UIStackView(arrangedSubviews: [
            nameLabel,
            bodyLabel,
            dataLabel
        ])
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        vStack.spacing = 16
        
        contentView.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: vStack.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: vStack.trailingAnchor)
        ])
        
    }
}
