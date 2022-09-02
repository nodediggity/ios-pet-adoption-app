//
//  ResourceView.swift
//  Paw
//
//  Created by Gordon Smith on 02/09/2022.
//

import Foundation

public protocol ResourceView {
    associatedtype ResourceViewModel
    
    func display(_ viewModel: ResourceViewModel)
}
