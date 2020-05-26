//
//  ResourceListCollectionViewControllerTests.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 29/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest
import Pokedex

class ResourceListCollectionViewController: UIViewController {

    private var loader: ListLoader?

    convenience init(loader: ListLoader) {
        self.init()
        self.loader = loader
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loader?.load { _ in }
    }
}

class ResourceListCollectionViewControllerTests: XCTestCase {

    func test_viewDidLoad_registersListCollectionViewCell() {
        let (_, loader) = makeSUT()

        XCTAssertEqual(loader.loadCallCount, 0)
    }

    func test_viewDidLoad_loadsFeed() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertEqual(loader.loadCallCount, 1)
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line)  -> (sut: ResourceListCollectionViewController, loader: LoaderSpy){
        let loader = LoaderSpy()
        let sut = ResourceListCollectionViewController(loader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }

    class LoaderSpy: ListLoader {
        private(set) var loadCallCount: Int = 0

        func load(completion: @escaping (RequestResult<ListItem>) -> Void) {
            loadCallCount += 1
        }
    }
}
