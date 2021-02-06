//
//  AppDelegateTests.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 06/02/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

@testable import Pokedex
import PokemonDomain
import XCTest

class AppDelegateTests: XCTestCase {
    
    func test_appDidFinishLaunching_configuresRootViewController() throws {
        let client = HTTPClientStub(.online([.listData]))
        let sut = AppDelegate(httpClient: client)
        sut.window = UIWindow()
        
        sut.configureWindow()
        
        let root = sut.window?.rootViewController
        
        let rootNavigation = try XCTUnwrap(root as? NavigationController)
        let listViewController = try XCTUnwrap(rootNavigation.topViewController as? ResourceListCollectionViewController)
        
        XCTAssertEqual(listViewController.numberOfRenderedResourceItems(), 8)
    }
    
    func test_appDidFinishLaunching_withItemSelection_navigatesToPokemonViewController() throws {
        let client = HTTPClientStub(.online([.listData]))
        let sut = AppDelegate(httpClient: client)
        sut.window = UIWindow()
        
        sut.configureWindow()
        
        let root = sut.window?.rootViewController
        
        let rootNavigation = try XCTUnwrap(root as? NavigationController)
        let listViewController = try XCTUnwrap(rootNavigation.topViewController as? ResourceListCollectionViewController)
        
        listViewController.simulateResourceItemSelection(item: 1)
        RunLoop.current.run(until: Date())
        
        let navigationController = listViewController.navigationController
        XCTAssertTrue(navigationController?.topViewController is PokemonViewController)
    }
}
