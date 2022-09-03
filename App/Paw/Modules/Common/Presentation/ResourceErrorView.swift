//
// ResourceErrorView.swift
//

import Foundation

public protocol ResourceErrorView {
    func display(_ viewModel: ResourceErrorViewModel)
}

public struct ResourceErrorViewModel {
    public let message: String?

    static var noError: ResourceErrorViewModel {
        ResourceErrorViewModel(message: nil)
    }

    static func error(message: String) -> ResourceErrorViewModel {
        ResourceErrorViewModel(message: message)
    }
}
