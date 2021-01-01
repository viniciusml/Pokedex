//
//  AppDelegate.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 25/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = NavigationController()
        
        let httpClient = AFHTTPClient()
        let listLoader = RemoteListLoader(client: httpClient)
        let listViewController = ResourceListUIComposer.resourceListComposedWith(
            listLoader: listLoader, selection: { pokemonURLString in
                let loader = RemotePokemonLoader(client: httpClient)
                let pokemonViewController = PokemonUIComposer.pokemonComposedWith(pokemonLoader: loader, urlString: pokemonURLString)
                navigationController.pushViewController(pokemonViewController, animated: true)
            })
        navigationController.setViewControllers([listViewController], animated: false)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}

public class NavigationController: UINavigationController {
    
    public override func viewDidLoad() {
        
        configure()
    }
    
    private func configure() {
        //Set Navigation bar transparent
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.barTintColor = .white
        navigationBar.tintColor = .tintColor
        
        //Set text from back button transparent
        let barButtonItemAppearance = UIBarButtonItem.appearance()
        barButtonItemAppearance.setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
        barButtonItemAppearance.setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .highlighted)
        
        //Set title color and font
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: Font.bold, size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.tintColor,
            NSAttributedString.Key.kern: NSNumber(floatLiteral: 1.3),
        ]
    }
}
