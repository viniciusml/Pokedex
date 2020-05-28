//
//  NavigationControllerRouterTests.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 28/05/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest
import Pokedex

public protocol Router {
    func routeTo(pokemon urlString: String)
}

class NavigationControllerRouter: Router {

    private let navigationController: UINavigationController

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func routeTo(pokemon urlString: String) {
        let controller = PokemonViewController()
        navigationController.pushViewController(controller, animated: true)
    }
}

class NavigationControllerRouterTests: XCTestCase {

    func test_routToPokemon_presentViewController() {
        let navigationController = UINavigationController()
        let sut = NavigationControllerRouter(navigationController)

        sut.routeTo(pokemon: "http://pokemon1.com")

        XCTAssertEqual(navigationController.viewControllers.count, 1)
    }

    func test_routToPokemon_presentPokemonViewController() {
        let navigationController = UINavigationController()
        let sut = NavigationControllerRouter(navigationController)

        sut.routeTo(pokemon: "http://pokemon1.com")

        XCTAssertTrue(navigationController.viewControllers.first is PokemonViewController)
    }
}
