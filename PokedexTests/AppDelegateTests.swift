//
//  AppDelegateTests.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 06/02/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

@testable import Pokedex
import XCTest

class AppDelegateTests: XCTestCase {
    
    func test_appDidFinishLaunching_configuresRootViewController() throws {
        let sut = AppDelegate()
        sut.window = UIWindow()
        
        sut.configureWindow()
        
        let root = sut.window?.rootViewController
        
        let rootNavigation = try XCTUnwrap(root as? NavigationController)
        XCTAssertTrue(rootNavigation.topViewController is ResourceListCollectionViewController)
    }
}
