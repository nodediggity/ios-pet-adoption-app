//
//  ResourceLoadingView.swift
//  Paw
//
//  Created by Gordon Smith on 02/09/2022.
//

import Foundation

public protocol ResourceLoadingView {
    func display(_ viewModel: ResourceLoadingViewModel)
}

public struct ResourceLoadingViewModel {
    public let isLoading: Bool
}
