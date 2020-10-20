//
//  NavigationControllerRouterTests.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 28/05/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest
import Pokedex

class NavigationControllerRouterTests: XCTestCase {

    let navigationController = NonAnimatedNavigationController()

    lazy var sut: NavigationControllerRouter = {
        return NavigationControllerRouter(navigationController)
    }()

    func test_routToPokemon_presentViewController() {
        sut.routeTo(pokemon: "http://pokemon1.com")

        XCTAssertEqual(navigationController.viewControllers.count, 1)
    }

    func test_routToPokemon_presentPokemonViewController() {
        sut.routeTo(pokemon: "http://pokemon1.com")

        XCTAssertTrue(navigationController.viewControllers.first is PokemonViewController)
    }

    // MARK: - Helpers

    class NonAnimatedNavigationController: UINavigationController {
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            super.pushViewController(viewController, animated: false)
        }
    }
}
