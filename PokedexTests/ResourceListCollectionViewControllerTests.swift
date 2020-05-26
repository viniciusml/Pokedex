//
//  ResourceListCollectionViewControllerTests.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 29/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest
import Pokedex

class ResourceListCollectionViewController: UICollectionViewController {

    private var loader: ListLoader?

    convenience init(loader: ListLoader) {
        self.init(collectionViewLayout: UICollectionViewLayout())
        self.loader = loader
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        collectionView.refreshControl?.beginRefreshing()
        load()
    }

    @objc private func load() {
        loader?.load { [weak self] _ in
            self?.collectionView.refreshControl?.endRefreshing()
        }
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

    func test_pullToRefresh_loadsList() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()

        sut.collectionView.refreshControl?.simulatePullToRefresh()
        XCTAssertEqual(loader.loadCallCount, 2)

        sut.collectionView.refreshControl?.simulatePullToRefresh()
        XCTAssertEqual(loader.loadCallCount, 3)
    }

    func test_viewDidLoad_showsLoadingIndicator() {
        let (sut, _) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.collectionView.refreshControl?.isRefreshing, true)
    }

    func test_viewDidLoad_hidesLoadingIndicatorOnLoaderCompletion() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeListLoading()

        XCTAssertEqual(sut.collectionView.refreshControl?.isRefreshing, false)
    }

    func test_pullToRefresh_showsLoadingIndicator() {
        let (sut, _) = makeSUT()

        sut.collectionView.refreshControl?.simulatePullToRefresh()

        XCTAssertEqual(sut.collectionView.refreshControl?.isRefreshing, true)
    }

    func test_pullToRefresh_hidesLoadingIndicatorOnLoaderCompletion() {
        let (sut, loader) = makeSUT()

        sut.collectionView.refreshControl?.simulatePullToRefresh()
        loader.completeListLoading()

        XCTAssertEqual(sut.collectionView.refreshControl?.isRefreshing, false)
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
        private var completions = [(RequestResult<[ResultItem]>) -> Void]()

        var loadCallCount: Int {
            completions.count
        }

        func load(completion: @escaping (RequestResult<[ResultItem]>) -> Void) {
            completions.append(completion)
        }

        func completeListLoading() {
            completions[0](.success([]))
        }
    }
}

private extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
