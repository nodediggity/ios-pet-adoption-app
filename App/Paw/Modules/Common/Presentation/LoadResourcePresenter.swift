//
// LoadResourcePresenter.swift
//

import Foundation

public final class LoadResourcePresenter<Resource, View: ResourceView> {
    public typealias Mapper = (Resource) throws -> View.ResourceViewModel

    private let resourceView: View
    private let loadingView: ResourceLoadingView?
    private let errorView: ResourceErrorView?
    private let mapper: Mapper

    public init(resourceView: View, loadingView: ResourceLoadingView? = .none, errorView: ResourceErrorView? = .none, mapper: @escaping Mapper) {
        self.resourceView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapper = mapper
    }

    public init(resourceView: View, loadingView: ResourceLoadingView? = .none, errorView: ResourceErrorView? = .none) where Resource == View.ResourceViewModel {
        self.resourceView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
        mapper = { $0 }
    }

    public func didStartLoading() {
        errorView?.display(.noError)
        loadingView?.display(ResourceLoadingViewModel(isLoading: true))
    }

    public func didFinishLoading(with resource: Resource) {
        do {
            resourceView.display(try mapper(resource))
            loadingView?.display(ResourceLoadingViewModel(isLoading: false))
        } catch {
            didFinishLoading(with: error)
        }
    }

    public func didFinishLoading(with error: Error) {
        errorView?.display(.error(message: error.localizedDescription))
        loadingView?.display(ResourceLoadingViewModel(isLoading: false))
    }
}
