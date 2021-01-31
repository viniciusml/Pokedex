//
//  ResourceListCollectionViewControllerTests.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 29/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest
import Pokedex
import PokemonDomain
import ViewControllerPresentationSpy

class ResourceListCollectionViewControllerTests: XCTestCase {

    func test_resourceListView_hasTitle() {
        let (sut, _) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.title, "Pokédex")
    }

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
        let item0 = makeResourceItem(name: "Pokemon")
        let item1 = makeResourceItem(name: "Pokemon1")
        let item2 = makeResourceItem(name: "Pokemon2")
        let item3 = makeResourceItem(name: "Pokemon3")
        let list = makeList(count: 4, next: "http://pokemon-url.com", previous: nil, results: [item0, item1, item2, item3])
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")

        loader.completeListLoading(with: list ,at: 0)
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
        let list1 = makeList(count: 1, next: "http://pokemon-url.com", previous: nil, results: [item0])
        let list2 = makeList(count: 4, next: "http://pokemon-url.com", previous: nil, results: [item0, item1, item2, item3])
        
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])

        loader.completeListLoading(with: list1, at: 0)
        assertThat(sut, isRendering: [item0])

        sut.simulateUserInitiatedReload()
        loader.completeListLoading(with: list2, at: 1)
        assertThat(sut, isRendering: [item0, item1, item2, item3])
    }

    func test_loadListCompletion_doesNotAlterCurrentLoadingStateOnError() {
        let item0 = makeResourceItem(name: "Pokemon")
        let list = makeList(count: 1, next: "http://pokemon-url.com", previous: nil, results: [item0])
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeListLoading(with: list, at: 0)
        assertThat(sut, isRendering: [item0])

        sut.simulateUserInitiatedReload()
        loader.completeListLoadingWithError(at: 1)
        assertThat(sut, isRendering: [item0])
    }

    func test_loadActions_preloadsNewDataWhenLastModelItemNearVisible() {
        let items = makeResourceItems(20)
        let list = makeList(count: 20, next: "http://pokemon-url.com", previous: nil, results: items)
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeListLoading(with: list)
        XCTAssertEqual(loader.loadCallCount, 1, "Expected no additional requests until last model item is near visible")

        sut.simulateResourceItemViewNearVisible(at: 0)
        XCTAssertEqual(loader.loadCallCount, 1, "Expected no additional requests until last model item is near visible")

        sut.simulateResourceItemViewNearVisible(at: items.count - sut.prefetchTrigger)
        XCTAssertEqual(loader.loadCallCount, 2, "Expected additional request once last model item is near visible")
    }

    func test_listPrefetchCompletion_rendersSuccessfullyAdditionalPageLoadedList() {
        let firstPageItems = makeResourceItems(40)
        let list1 = makeList(count: 40, next: "http://pokemon-url.com", previous: nil, results: firstPageItems)
        let secondPageItems = makeResourceItems(20)
        let list2 = makeList(count: 20, next: "http://pokemon-url.com", previous: "previous page", results: secondPageItems)

        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()

        loader.completeListLoading(with: list1, at: 0)
        assertThat(sut, isRendering: firstPageItems)

        sut.simulateResourceItemViewNearVisible(at: firstPageItems.count - sut.prefetchTrigger)
        loader.completeListLoading(with: list2, at: 1)
        assertThat(sut, isRendering: firstPageItems + secondPageItems)
    }

    func test_itemSelection_notifiesDelegateWithSelection() {
        let item0 = makeResourceItem(name: "Pokemon", url: "http://pokemon.com")
        let item1 = makeResourceItem(name: "Pokemon1", url: "http://pokemon1.com")
        let item2 = makeResourceItem(name: "Pokemon2", url: "http://pokemon2.com")
        let list = makeList(count: 3, next: "http://pokemon-url.com", previous: nil, results: [item0, item1, item2])
        
        var receivedPokemonURL = String()
        let (sut, loader) = makeSUT { receivedPokemonURL = $0 }
        sut.loadViewIfNeeded()

        loader.completeListLoading(with: list)

        sut.simulateResourceItemSelection(item: 0)

        XCTAssertEqual(receivedPokemonURL, "http://pokemon.com")
    }
    
    func test_loadActionFailure_displaysErrorAlertOnMainThread() {
        let (sut, loader) = makeSUT()
        let alertVerifier = AlertVerifier()
        
        let exp = expectation(description: "Wait for alert presentation")
        alertVerifier.testCompletion = { exp.fulfill() }
        
        sut.loadViewIfNeeded()
        loader.completeListLoadingWithError(at: 0)
        
        waitForExpectations(timeout: 0.0001)
        
        alertVerifier.verify(
            title: "Alert",
            message: "An error ocurred. Please try again",
            animated: true,
            actions: [
                .default("OK")],
            presentingViewController: sut
        )
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line, selection: @escaping (String) -> Void = { _ in })  -> (sut: ResourceListCollectionViewController, loader: RemoteListLoaderSpy) {
        let client = HTTPClientSpy()
        let loader = RemoteListLoaderSpy(client: client)
        let sut = ResourceListUIComposer.resourceListComposedWith(listLoader: loader, selection: selection)
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
}

extension ResourceListCollectionViewController {
    func simulateUserInitiatedReload() {
        collectionView.refreshControl?.simulatePullToRefresh()
    }

    var isShowingLoadingIndicator: Bool {
        collectionView.refreshControl?.isRefreshing == true
    }

    var prefetchTrigger: Int { 10 }

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
        let dl = collectionView.delegate
        let index = IndexPath(item: item, section: resourceItemsSection)
        let cell = listItem(at: item)!
        dl?.collectionView?(collectionView, willDisplay: cell, forItemAt: index)
    }

    func simulateResourceItemSelection(item: Int) {
        let dl = collectionView.delegate
        let indexPath = IndexPath(item: item, section: resourceItemsSection)
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
