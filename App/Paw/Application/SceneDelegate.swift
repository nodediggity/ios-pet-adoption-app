//
// SceneDelegate.swift
//

import UIKit
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: .init(configuration: .ephemeral))
    }()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        
        let rootViewController = UITabBarController()
        rootViewController.tabBar.tintColor = UIColor(hex: "F2968F")
        rootViewController.tabBar.unselectedItemTintColor = .lightGray

        rootViewController.viewControllers = makeTabs(tabs: [.feed, .search, .profile])
        window.rootViewController = rootViewController
        
        window.makeKeyAndVisible()
        self.window = window
    }
}

private extension SceneDelegate {
    func makeRemoteFeedLoader() -> AnyPublisher<[FeedItem], Error> {
        do {
            let request = try URLRequestBuilder()
                .set(scheme: "http")
                .set(host: "localhost")
                .set(path: ["feed"])
                .build()
            
            return httpClient
                .dispatch(request)
                .tryMap(FeedResponseMapper.map)
                .eraseToAnyPublisher()
            
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    func makeRemoteImageLoader(imageURL: URL) -> AnyPublisher<Data, Error> {
        let request = URLRequest(url: imageURL)
        return httpClient
            .dispatch(request)
            .tryMap(ImageDataResponseMapper.map)
            .eraseToAnyPublisher()
    }
    
    func makeFeedScene() -> UIViewController {
        FeedUIComposer.compose(loader: makeRemoteFeedLoader, imageLoader: makeRemoteImageLoader) { _ in }
    }
    
    func makeTabs(tabs: [Tabs]) -> [UINavigationController] {
        let navControllers = tabs.indices
            .map { index -> UINavigationController in
                let tab = tabs[index]
                let navController = UINavigationController()
                navController.tabBarItem = .init(title: .none, image: tab.iconOff, selectedImage: tab.iconOn)
                return navController
            }

        return zip(tabs, navControllers).map { tab, navController in
            switch tab {
            case .feed: navController.setViewControllers([makeFeedScene()], animated: false)
            default: navController.setViewControllers([UIViewController()], animated: false)
            }
            
            navController.showLogo()
            return navController
        }
    }
}
