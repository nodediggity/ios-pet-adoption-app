//
// SceneDelegate.swift
//

import Combine
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private lazy var httpClient: HTTPClient = URLSessionHTTPClient(session: .init(configuration: .ephemeral))

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)

        let rootViewController = UITabBarController()
        rootViewController.tabBar.tintColor = UIColor(hex: "F2968F")
        rootViewController.tabBar.unselectedItemTintColor = .lightGray

        rootViewController.viewControllers = makeTabs(tabs: [.feed, .alerts, .profile])
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

    func makeRemoteProfileLoader(id: UUID) -> () -> AnyPublisher<Profile, Error> {
        { [httpClient] in
            do {
                let request = try URLRequestBuilder()
                    .set(scheme: "http")
                    .set(host: "localhost")
                    .set(path: ["profile", "\(id.uuidString)"])
                    .build()

                return httpClient
                    .dispatch(request)
                    .tryMap(ProfileResponseMapper.map)
                    .eraseToAnyPublisher()

            } catch {
                return Fail(error: error).eraseToAnyPublisher()
            }
        }
    }

    func makeFeedScene() -> UIViewController {
        FeedUIComposer.compose(
            loader: makeRemoteFeedLoader,
            imageLoader: makeRemoteImageLoader,
            selection: showFeedDetailScene
        )
    }

    func showFeedDetailScene(item: FeedItem) {
        let controller = FeedDetailUIComposer.compose(
            loader: makeRemoteProfileLoader(id: item.id),
            imageLoader: makeRemoteImageLoader
        )
        showOnTab(controller)
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
            case .feed:
                navController.setViewControllers([makeFeedScene()], animated: false)
            case .alerts:
                navController.setViewControllers([PlaceholderViewController(text: "Alerts")], animated: false)
            case .profile:
                navController.setViewControllers([PlaceholderViewController(text: "Your Profile")], animated: false)
            }
            navController.configureLogo()
            return navController
        }
    }

    func showOnTab(_ controller: UIViewController) {
        let tabBarController = window?.rootViewController as? UITabBarController
        tabBarController?.selectedViewController?.show(controller, sender: nil)
    }
}
