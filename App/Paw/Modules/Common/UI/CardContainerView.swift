//
//  CardContainerView.swift
//  Paw
//
//  Created by Gordon Smith on 02/09/2022.
//

import UIKit

public final class CardContainerView: UIView {
    private var didlLayoutSubviews = false
    
    public required init() {
        super.init(frame: .zero)
        configureUI()
    }
        
    required init?(coder: NSCoder) {
        nil
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        guard !didlLayoutSubviews else { return }
        didlLayoutSubviews = true
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.quaternarySystemFill.cgColor
    }
}

private extension CardContainerView {
    func configureUI() {
        layer.cornerRadius = 12
        clipsToBounds = true
    }
}
