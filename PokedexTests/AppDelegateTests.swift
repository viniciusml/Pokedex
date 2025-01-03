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
        
        let listViewController = try getListViewController(from: sut.window)
        XCTAssertEqual(listViewController.numberOfRenderedResourceItems(), 8)
    }
    
    func test_appDidFinishLaunching_withItemSelection_navigatesToPokemonViewController() throws {
        let client = HTTPClientStub(.online([.listData]))
        let sut = AppDelegate(httpClient: client)
        sut.window = UIWindow()
        
        sut.configureWindow()
        let listViewController = try getListViewController(from: sut.window)
        
        listViewController.simulateResourceItemSelection(item: 1)
        RunLoop.current.run(until: Date())
        
        let navigationController = listViewController.navigationController
        XCTAssertTrue(navigationController?.topViewController is PokemonViewController)
    }
    
    func test_appDidFinishLaunching_withURL_navigatesToPokemonViewController() throws {
        let client = HTTPClientStub(.online([.listData]))
        let sut = AppDelegate(httpClient: client)
        sut.window = UIWindow()
        
        sut.configureWindow(with: [.url: URL(string: "https://pokeapi.co/api/v2/pokemon/1/") as Any])
        RunLoop.current.run(until: Date() + 0.3)
        
        let root = sut.window?.rootViewController
        let rootNavigation = try XCTUnwrap(root as? NavigationController, "expected root as NavigationController, found \(String(describing: root)) instead")
        XCTAssertTrue(rootNavigation.topViewController is PokemonViewController, "TopViewController is: \(String(describing: rootNavigation.topViewController))")
    }
    
    // MARK: Helpers
    
    private func getListViewController(from window: UIWindow?, file: StaticString = #filePath, line: UInt = #line) throws -> ResourceListCollectionViewController {
        let root = window?.rootViewController
        let rootNavigation = try XCTUnwrap(root as? NavigationController, "expected root as NavigationController, found \(String(describing: root)) instead")
        let listViewController = try XCTUnwrap(rootNavigation.topViewController as? ResourceListCollectionViewController, "expected topViewController as ResourceListCollectionViewController, found \(String(describing: rootNavigation.topViewController)) instead")
        
        return listViewController
    }
}
