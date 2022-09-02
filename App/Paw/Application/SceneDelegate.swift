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

        window.rootViewController = FeedUIComposer.compose(loader: makeRemoteFeedLoader)
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
}
