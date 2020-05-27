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
    private var collectionModel = [ResultItem]()

    convenience init(loader: ListLoader) {
        self.init(collectionViewLayout: UICollectionViewLayout())
        self.loader = loader
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        load()
    }

    @objc private func load() {
        collectionView.refreshControl?.beginRefreshing()

        loader?.load { [weak self] result in
            self?.collectionModel = (try? result.get()) ?? []
            self?.collectionView.reloadData()
            self?.collectionView.refreshControl?.endRefreshing()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionModel.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellModel = collectionModel[indexPath.item]
        let cell = ListCell()
        cell.nameLabel.text = cellModel.name
        return cell
    }
}

class ResourceListCollectionViewControllerTests: XCTestCase {

    func test_loadActions_requestsListFromLoader() {
        let (sut, loader) = makeSUT()

        XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading requests before the view is loaded")

        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadCallCount, 1, "Expected a loading request once the view is loaded")

        sut.simulateUserInitiatedReload()
        XCTAssertEqual(loader.loadCallCount, 2, "Expected another loading request once user initiates a load")

        sut.simulateUserInitiatedReload()
        XCTAssertEqual(loader.loadCallCount, 3, "Expected a third loading request once user initiates another load")
    }

    func test_loadingFeedIndicator_isVisibleWhileLoadingList() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")

        loader.completeListLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading is completed")

        sut.simulateUserInitiatedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")

        loader.completeListLoading(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading is completed")
    }

    func test_loadListCompletion_rendersSuccessfullyLoadedList() {
        let item0 = makeResourceItem(name: "Pokemon", url: "http://pokemon-url.com")

        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.numberOfRenderedResourceItems(), 0)

        loader.completeListLoading(with: [item0], at: 0)
        XCTAssertEqual(sut.numberOfRenderedResourceItems(), 1)

        let view = sut.listItem(at: 0) as? ListCell
        XCTAssertNotNil(view)
        XCTAssertEqual(view?.pokemonName, item0.name)
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line)  -> (sut: ResourceListCollectionViewController, loader: LoaderSpy){
        let loader = LoaderSpy()
        let sut = ResourceListCollectionViewController(loader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }

    private func makeResourceItem(name: String, url: String) -> ResultItem {
        ResultItem(name: "Pokemon", url: "http://pokemon-url.com")
    }

    class LoaderSpy: ListLoader {
        private var completions = [(RequestResult<[ResultItem]>) -> Void]()

        var loadCallCount: Int {
            completions.count
        }

        func load(completion: @escaping (RequestResult<[ResultItem]>) -> Void) {
            completions.append(completion)
        }

        func completeListLoading(with list: [ResultItem] = [], at index: Int = 0) {
            completions[index](.success(list))
        }
    }
}

private extension ResourceListCollectionViewController {
    func simulateUserInitiatedReload() {
        collectionView.refreshControl?.simulatePullToRefresh()
    }

    var isShowingLoadingIndicator: Bool {
        collectionView.refreshControl?.isRefreshing == true
    }

    func numberOfRenderedResourceItems() -> Int {
        collectionView.numberOfItems(inSection: resourceItemsSection)
    }

    private var resourceItemsSection: Int { 0 }

    func listItem(at item: Int) -> UICollectionViewCell? {
        let ds = collectionView.dataSource
        let index = IndexPath(item: item, section: resourceItemsSection)
        return ds?.collectionView(collectionView, cellForItemAt: index)
    }
}

extension ListCell {
    var pokemonName: String? {
        nameLabel.text
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
