//
//  NavigationControllerRouterTests.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 28/05/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest

public protocol Router {
    func routeTo(pokemon urlString: String)
}

class NavigationControllerRouter: Router {

    private let navigationController: UINavigationController

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func routeTo(pokemon urlString: String) {
        navigationController.pushViewController(UIViewController(), animated: false)
    }
}

class NavigationControllerRouterTests {

    func test_routToPokemon_presentViewController() {
        let navigationController = UINavigationController()
        let sut = NavigationControllerRouter(navigationController)

        sut.routeTo(pokemon: "http://pokemon1.com")

        XCTAssertEqual(navigationController.viewControllers.count, 1)
    }
}
