//
//  AppDelegate.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 25/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import PokemonDomain
import UIKit

private class EmptyClient: HTTPClient {
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        fatalError("unimplemented")
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private lazy var httpClient: HTTPClient = {
        HTTPClientWithStubbedComposite(
            prod: HTTPClientMainQueueDecorator(AFHTTPClient()),
            stubbed: EmptyClient(),
            typeProvider: HTTPClientTypeProvider())
    }()
    
    private lazy var navigationController: NavigationController = {
        NavigationController()
    }()
    
    private lazy var imageLoader: RemoteImageLoader = {
        RemoteImageLoader(client: httpClient)
    }()
    
    convenience init(httpClient: HTTPClient) {
        self.init()
        self.httpClient = httpClient
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        configureWindow(with: launchOptions)

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        showPokemonViewController(withURL: url.absoluteString)
        return true
    }
    
    func configureWindow(with launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.disableAnimationsForUITests()

        let listLoader = RemoteListLoader(client: httpClient)
        
        let listViewController = ResourceListUIComposer.resourceListComposedWith(
            listLoader: listLoader, selection: showPokemonViewController(withURL:))
        navigationController.setViewControllers([listViewController], animated: false)
        
        if let url = launchOptions?[.url] as? URL {
            showPokemonViewController(withURL: url.absoluteString)
        }
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func showPokemonViewController(withURL pokemonURLString: String) {
        let loader = RemotePokemonLoader(client: self.httpClient)
        let pokemonViewController = PokemonUIComposer.pokemonComposedWith(
            pokemonLoader: loader,
            imageLoader: imageLoader,
            urlString: pokemonURLString)
        
        let newViewControllerStack = [navigationController.viewControllers.first, pokemonViewController].compactMap { $0 }
        navigationController.setViewControllers(newViewControllerStack, animated: true)
    }
}

private extension UIWindow {

    func disableAnimationsForUITests() {
        if ProcessInfo.processInfo.arguments.contains("UITest") {
            UIView.setAnimationsEnabled(false)
            window?.layer.speed = 2000
        }
    }
}
