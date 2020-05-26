//
//  ResourceListCollectionViewControllerTests.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 29/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest

class ResourceListCollectionViewController {
    init(loader: ResourceListCollectionViewControllerTests.LoaderSpy) {

    }
}

class ResourceListCollectionViewControllerTests: XCTestCase {

    func test_viewDidLoad_registersListCollectionViewCell() {
        let loader = LoaderSpy()
        _ = ResourceListCollectionViewController(loader: loader)

        XCTAssertEqual(loader.loadCallCount, 0)
    }

    // MARK: - Helpers

    class LoaderSpy {
        private(set) var loadCallCount: Int = 0
    }
}
