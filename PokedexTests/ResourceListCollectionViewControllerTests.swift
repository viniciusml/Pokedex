//
//  ResourceListCollectionViewControllerTests.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 29/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest
import Pokedex

class ResourceListCollectionViewControllerTests: XCTestCase {

    func test_resourceListView_hasTitle() {
        let (sut, _, _) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.title, "Pokédex")
    }

    func test_loadActions_requestsListFromLoader() {
        let (sut, loader, _) = makeSUT()

        XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading requests before the view is loaded")

        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadCallCount, 1, "Expected a loading request once the view is loaded")

        sut.simulateUserInitiatedReload()
        XCTAssertEqual(loader.loadCallCount, 2, "Expected another loading request once user initiates a load")

        sut.simulateUserInitiatedReload()
        XCTAssertEqual(loader.loadCallCount, 3, "Expected a third loading request once user initiates another load")
    }

    func test_loadingFeedIndicator_isVisibleWhileLoadingList() {
        let (sut, loader, _) = makeSUT()

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

        let (sut, loader, _) = makeSUT()

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
        let (sut, loader, _) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeListLoading(with: [item0], at: 0)
        assertThat(sut, isRendering: [item0])

        sut.simulateUserInitiatedReload()
        loader.completeListLoadingWithError(at: 1)
        assertThat(sut, isRendering: [item0])
    }

    func test_loadActions_preloadsNewDataWhenLastModelItemNearVisible() {
        let items = makeResourceItems(10)
        let (sut, loader, _) = makeSUT()

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

        let (sut, loader, _) = makeSUT()
        sut.loadViewIfNeeded()

        loader.completeListLoading(with: firstPageItems, at: 0)
        assertThat(sut, isRendering: firstPageItems)

        sut.simulateResourceItemViewNearVisible(at: firstPageItems.count - sut.prefetchTrigger)
        loader.completeListLoading(with: secondPageItems, at: 1)
        assertThat(sut, isRendering: firstPageItems + secondPageItems)
    }

    func test_cellSelected_notifiesDelegateWithSelection() {
        let item0 = makeResourceItem(name: "Pokemon", url: "http://pokemon.com")
        let item1 = makeResourceItem(name: "Pokemon1", url: "http://pokemon1.com")
        let item2 = makeResourceItem(name: "Pokemon2", url: "http://pokemon2.com")

        var receivedPokemonURL = String()
        let (sut, loader, _) = makeSUT { receivedPokemonURL = $0 }
        sut.loadViewIfNeeded()

        loader.completeListLoading(with: [item0, item1, item2])

        sut.simulateResourceItemSelection(item: 0)

        XCTAssertEqual(receivedPokemonURL, "http://pokemon.com")
    }

    func test_loadAction_displaysAlertOnError() {
        let item0 = makeResourceItem(name: "Pokemon")
        let item1 = makeResourceItem(name: "Pokemon1")
        let item2 = makeResourceItem(name: "Pokemon2")

        let (sut, loader, alertPresenter) = makeSUT()
        sut.loadViewIfNeeded()

        loader.completeListLoadingWithError(at: 0)
        XCTAssertEqual(alertPresenter.alertsPresented.count, 1)

        sut.simulateUserInitiatedReload()
        loader.completeListLoading(with: [item0, item1, item2], at: 1)

        sut.simulateResourceItemViewNearVisible(at: 0)
        loader.completeListLoadingWithError(at: 2)
        XCTAssertEqual(alertPresenter.alertsPresented.count, 2)
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line, selection: @escaping (String) -> Void = { _ in })  -> (sut: ResourceListCollectionViewController, loader: LoaderSpy, alerPresenter: AlertPresenterSpy) {
        let loader = LoaderSpy()
        let alertPresenter = AlertPresenterSpy()
        let sut = ResourceListCollectionViewController(loader: loader, alertPresenter: alertPresenter, selection: selection)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader, alertPresenter)
    }

    private class AlertPresenterSpy: AlertPresenter {

        var alertsPresented = [(title: String, message: String)]()

        func presentAlert(title: String, message: String) {
            alertsPresented.append((title, message))
        }
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

    func simulateResourceItemSelection(item: Int) {
        let dl = collectionView.delegate
        let indexPath = IndexPath(item: item, section: 0)
        dl?.collectionView?(collectionView, didSelectItemAt: indexPath)
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
