//
//  NavigationControllerRouter.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 28/05/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

public class NavigationControllerRouter: Router {

    private let navigationController: UINavigationController

    public init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func routeTo(pokemon urlString: String) {
        let controller = PokemonViewController()
        navigationController.pushViewController(controller, animated: true)
    }
}
