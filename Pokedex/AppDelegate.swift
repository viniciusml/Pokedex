//
//  AppDelegate.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 25/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import PokemonDomain
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        configureWindow(with: launchOptions)

        return true
    }
    
    func configureWindow(with launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = NavigationController()
        
        let httpClient = HTTPClientMainQueueDecorator(AFHTTPClient())
        let listLoader = RemoteListLoader(client: httpClient)
        let imageLoader = RemoteImageLoader(client: httpClient)
        
        let listViewController = ResourceListUIComposer.resourceListComposedWith(
            listLoader: listLoader, selection: { pokemonURLString in
                let loader = RemotePokemonLoader(client: httpClient)
                let pokemonViewController = PokemonUIComposer.pokemonComposedWith(pokemonLoader: loader, imageLoader: imageLoader, urlString: pokemonURLString)
                navigationController.pushViewController(pokemonViewController, animated: true)
            })
        navigationController.setViewControllers([listViewController], animated: false)
        
        if let id = launchOptions?[UIApplication.LaunchOptionsKey.url] as? URL {
            debugPrint("🔴🟢 \(id) 🔴🟢")
        }
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
