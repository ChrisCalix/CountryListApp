//
//  SceneDelegate.swift
//  CountryListApp
//
//  Created by Sonic on 13/11/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var baseURL = URL(string: "https://restcountries.com")!
    
    private lazy var navigationController = UINavigationController(
        rootViewController: CountryListUIComposer.countryComposedWith(
            countryLoader: self.makeRemoteCountryLoader(),
            imageLoader: self.makeRemoteImageLoader(), 
            loadingView: self.makeLoadingView(),
            selection: self.showDetails
        )
    )
    
    convenience init(httpClient: HTTPClient) {
        self.init()
        self.httpClient = httpClient
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        configureWindow()
    }
    
    // MARK: Helpers
    
    func configureWindow() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func makeRemoteCountryLoader() -> CountryLoader {
        let url = CountryListEndpoint.getAll.url(baseURL: baseURL)
        let remoteCountryLoader = RemoteCountryListLoader(url: url, client: httpClient)
        return remoteCountryLoader
    }
    
    private func makeRemoteImageLoader() -> ImageDataLoader {
        return RemoteImageDataLoader(client: httpClient)
    }

    private func makeLoadingView() -> Loading {
        return LoadingView()
    }

    func showDetails(for name: String?) {
        
    }
}

