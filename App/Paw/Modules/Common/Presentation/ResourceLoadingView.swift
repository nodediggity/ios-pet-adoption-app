//
// ResourceLoadingView.swift
//

import Foundation

public protocol ResourceLoadingView {
    func display(_ viewModel: ResourceLoadingViewModel)
}

public struct ResourceLoadingViewModel {
    public let isLoading: Bool
}
