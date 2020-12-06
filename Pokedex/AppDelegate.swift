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
        
        let httpClient = AFHTTPClient()
        let listLoader = RemoteListLoader(client: httpClient)
        let listViewController = ResourceListUIComposer.resourceListComposedWith(
            listLoader: listLoader, selection: { _ in })
        let navigationController = UINavigationController(rootViewController: listViewController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        //Set Navigation bar transparent
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.barTintColor = .white
        navigationController.navigationBar.tintColor = .tintColor

        //Set text from back button transparent
        let barButtonItemAppearance = UIBarButtonItem.appearance()
        barButtonItemAppearance.setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
        barButtonItemAppearance.setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .highlighted)

        //Set title color and font
        navigationController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: Font.bold, size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.tintColor,
            NSAttributedString.Key.kern: NSNumber(floatLiteral: 1.3),
        ]

        return true
    }
}

public final class ResourceListUIComposer {
    private init() {}
    
    public static func resourceListComposedWith(listLoader: RemoteListLoader, selection: @escaping ((String) -> Void)) -> ResourceListCollectionViewController {
        let listViewModel = ListViewModel(listLoader: listLoader, url: URL(string: "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=40")!)
        let refreshController = RefreshViewController(viewModel: listViewModel)
        let listViewController = ResourceListCollectionViewController(
            refreshController: refreshController,
            selection: selection)
        listViewModel.onListLoad = adaptResourceToCellControllers(forwardingTo: listViewController, using: listViewModel)
        listViewModel.onListFailure = { [weak listViewController] in
            listViewController?.handleLoadFailure()
        }
        return listViewController
    }
    
    private static func adaptResourceToCellControllers(forwardingTo controller: ResourceListCollectionViewController, using viewModel: ListViewModel) -> (ListItem) -> Void {
        return { [weak controller, weak viewModel] listItem in
            guard let viewModel = viewModel else { return }
            var collectionModel = [ResourceListCellController]()
            if viewModel.isFirstPage {
                collectionModel = listItem.results.map { model in
                    ResourceListCellController(model: model)
                }
            } else {
                let currentCollectionModel = controller?.collectionModel ?? []
                collectionModel = currentCollectionModel + listItem.results.map { model in
                    ResourceListCellController(model: model)
                }
            }
            controller?.collectionModel = collectionModel
        }
    }
}
