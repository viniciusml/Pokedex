//
//  ResourceListCollectionViewControllerTests.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 29/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest
import Pokedex

class ResourceListCollectionViewController: UICollectionViewController, UICollectionViewDataSourcePrefetching {

    private var loader: ListLoader?
    private var collectionModel = [ResultItem]()

    private var prefetchTriggerCount: Int {
        collectionModel.count - 6
    }

    convenience init(loader: ListLoader) {
        self.init(collectionViewLayout: UICollectionViewLayout())
        self.loader = loader
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        collectionView.prefetchDataSource = self
        collectionView.register(ListCell.self)
        load()
    }

    @objc private func load() {
        collectionView.refreshControl?.beginRefreshing()

        loader?.load { [weak self] result in
            if let items = try? result.get() {
                self?.collectionModel = items
                self?.collectionView.reloadData()
            }

            self?.collectionView.refreshControl?.endRefreshing()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionModel.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellModel = collectionModel[indexPath.item]
        let cell = collectionView.dequeueReusableCell(type: ListCell.self, for: indexPath)
        cell.nameLabel.text = cellModel.name
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isDisplayingCell) {
            loader?.load { [weak self] result in
                guard let self = self else { return }

                if let items = try? result.get() {
                    self.collectionModel.append(contentsOf: items)

                    let indexesToReload = self.calculateIndexPathsToReload(from: items)
                    self.collectionView.insertItems(at: indexesToReload)
                    self.collectionView.reloadItems(at: indexesToReload)
                }
            }
        }
    }

    func calculateIndexPathsToReload(from newItems: [ResultItem]) -> [IndexPath] {

        let startIndex = collectionModel.count - newItems.count

        let endIndex = startIndex + newItems.count

        return (startIndex..<endIndex).map { IndexPath(item: $0, section: 0) }
    }

    func isDisplayingCell(for indexPath: IndexPath) -> Bool {
        indexPath.item >= prefetchTriggerCount
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
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes successfully")

        sut.simulateUserInitiatedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")

        loader.completeListLoadingWithError(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading completes with error")
    }

    func test_loadListCompletion_rendersSuccessfullyLoadedList() {
        let item0 = makeResourceItem(name: "Pokemon")
        let item1 = makeResourceItem(name: "Pokemon1")
        let item2 = makeResourceItem(name: "Pokemon2")
        let item3 = makeResourceItem(name: "Pokemon3")

        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])

        loader.completeListLoading(with: [item0], at: 0)
        assertThat(sut, isRendering: [item0])

        sut.simulateUserInitiatedReload()
        loader.completeListLoading(with: [item0, item1, item2, item3], at: 1)
        assertThat(sut, isRendering: [item0, item1, item2, item3])
    }

    func test_loadListCompletion_doesNotAlterCurrentLoadingStateOnError() {
        let item0 = makeResourceItem(name: "Pokemon")
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeListLoading(with: [item0], at: 0)
        assertThat(sut, isRendering: [item0])

        sut.simulateUserInitiatedReload()
        loader.completeListLoadingWithError(at: 1)
        assertThat(sut, isRendering: [item0])
    }

    func test_loadActions_preloadsNewDataWhenLastModelItemNearVisible() {
        let items = makeResourceItems(10)
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeListLoading(with: items)
        XCTAssertEqual(loader.loadCallCount, 1, "Expected no additional requests until last model item is near visible")

        sut.simulateResourceItemViewNearVisible(at: 0)
        XCTAssertEqual(loader.loadCallCount, 1, "Expected no additional requests until last model item is near visible")

        sut.simulateResourceItemViewNearVisible(at: sut.prefetchTrigger)
        XCTAssertEqual(loader.loadCallCount, 2, "Expected additional request once last model item is near visible")
    }

    func test_listPrefetchCompletion_rendersSuccessfullyAdditionalPageLoadedList() {
        let firstPageItems = makeResourceItems(10)
        let secondPageItems = makeResourceItems(10)

        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()

        loader.completeListLoading(with: firstPageItems, at: 0)
        assertThat(sut, isRendering: firstPageItems)

        sut.simulateResourceItemViewNearVisible(at: firstPageItems.count - sut.prefetchTrigger)
        loader.completeListLoading(with: secondPageItems, at: 1)
        assertThat(sut, isRendering: firstPageItems + secondPageItems)
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line)  -> (sut: ResourceListCollectionViewController, loader: LoaderSpy){
        let loader = LoaderSpy()
        let sut = ResourceListCollectionViewController(loader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }

    private func assertThat(_ sut: ResourceListCollectionViewController, isRendering list: [ResultItem], file: StaticString = #file, line: UInt = #line) {
        guard sut.numberOfRenderedResourceItems() == list.count else {
            return XCTFail("Expected \(list.count) items, got \(sut.numberOfRenderedResourceItems()) instead", file: file, line: line)
        }

        list.enumerated().forEach { index, item in
            assertThat(sut, hasViewConfiguredFor: item, at: index, file: file, line: line)
        }
    }

    private func assertThat(_ sut: ResourceListCollectionViewController, hasViewConfiguredFor item: ResultItem, at index: Int, file: StaticString = #file, line: UInt = #line) {
        let view = sut.listItem(at: index)

        guard let cell = view as? ListCell else {
            return XCTFail("Expected \(ListCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }

        XCTAssertTrue(cell.pokeImage.superview == cell)
        XCTAssertEqual(cell.nameLabel.text, item.name, "Expected name text to be \(String(describing: item.name)) for label at index \(index)", file: file, line: line)
    }

    private func makeResourceItem(name: String, url: String = "http://pokemon-url.com") -> ResultItem {
        ResultItem(name: name, url: url)
    }

    private func makeResourceItems(_ quantity: Int) -> [ResultItem] {
        var array = [ResultItem]()
        for i in 0...quantity {
            array.append(makeResourceItem(name: "Pokemon\(i)"))
        }
        return array
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

        func completeListLoadingWithError(at index: Int) {
            completions[index](.failure(.connectivity))
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

    var prefetchTrigger: Int { 6 }

    func numberOfRenderedResourceItems() -> Int {
        collectionView.numberOfItems(inSection: resourceItemsSection)
    }

    private var resourceItemsSection: Int { 0 }

    func listItem(at item: Int) -> UICollectionViewCell? {
        let ds = collectionView.dataSource
        let index = IndexPath(item: item, section: resourceItemsSection)
        return ds?.collectionView(collectionView, cellForItemAt: index)
    }

    func simulateResourceItemViewNearVisible(at item: Int) {
        let ds = collectionView.prefetchDataSource
        let index = IndexPath(item: item, section: resourceItemsSection)
        ds?.collectionView(collectionView, prefetchItemsAt: [index])
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
