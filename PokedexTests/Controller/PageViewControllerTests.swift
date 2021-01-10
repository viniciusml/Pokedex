//
//  PageViewControllerTests.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 30/12/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest
import Pokedex

class PageViewControllerTests: XCTestCase {
    
    func test_init_hasZeroPages() {
        XCTAssertTrue(makeSUT().viewControllers!.isEmpty)
    }
    
    func test_init_setsPreferredTransitionStyle() {
        XCTAssertEqual(makeSUT().transitionStyle, .scroll)
    }
    
    func test_init_setsPreferredNavigationOrientation() {
        XCTAssertEqual(makeSUT().navigationOrientation, .horizontal)
    }
    
    func test_viewDidLoad_withMoreThanZeroPages_setsInitialViewController() {
        let pages = makePages(count: 1)
        let sut = makeSUT(pages: pages)
        
        XCTAssertEqual(sut.viewControllers, pages)
    }
    
    func test_viewControllerAfter_selectsNextIndex() {
        let pages = makePages(count: 2)
        
        let sut = makeSUT(pages: pages)
        let controllerAfter = sut.controllerAfter(pages[0])
        
        XCTAssertEqual(controllerAfter, pages[1])
    }
    
    func test_viewControllerAfterTwice_selectsSecondNextIndex() {
        let pages = makePages(count: 3)
        
        let sut = makeSUT(pages: pages)
        let controllerAfter = sut.controllerAfter(pages[0])
        let secondControllerAfter = sut.controllerAfter(controllerAfter!)
        
        XCTAssertEqual(secondControllerAfter, pages[2])
    }
    
    func test_viewControllerAfter_whenMaxNumberOfPagesReached_selectsToFirstController() {
        let pages = makePages(count: 2)
        
        let sut = makeSUT(pages: pages)
        let controllerAfter: UIViewController? = sut.controllerAfter(pages[1])
        
        XCTAssertEqual(controllerAfter, pages[0])
    }
    
    func test_viewControllerBefore_selectsPreviousIndex() {
        let pages = makePages(count: 2)
        
        let sut = makeSUT(pages: pages)
        let controllerBefore = sut.controllerBefore(pages[1])
        
        XCTAssertEqual(controllerBefore, pages[0])
    }
    
    func test_viewControllerBeforeTwice_selectsSecondPreviousIndex() {
        let pages = makePages(count: 3)
        
        let sut = makeSUT(pages: pages)
        let controllerBefore = sut.controllerBefore(pages[2])
        let secondControllerBefore = sut.controllerBefore(controllerBefore!)
        
        XCTAssertEqual(secondControllerBefore, pages[0])
    }
    
    func test_viewControllerBefore_whenInFirstPage_selectsLastController() {
        let pages = makePages(count: 2)
        
        let sut = makeSUT(pages: pages)
        let controllerBefore: UIViewController? = sut.controllerBefore(pages[0])
        
        XCTAssertEqual(controllerBefore, pages[1])
    }
    
    func test_presentationCount_setsCorrectNumberOfPages() {
        let pages = makePages(count: 1)
        
        let sut = makeSUT(pages: pages)
        let presentationCount = sut.dataSource?.presentationCount?(for: sut)
        
        XCTAssertEqual(presentationCount, pages.count)
    }
    
    func test_presentationIndex_initiatesAtFirstIndex() {
        let sut = makeSUT(pages: makePages(count: 1))
        let presentationIndex = sut.dataSource?.presentationIndex!(for: sut)
        
        XCTAssertEqual(presentationIndex, 0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(pages: [UIViewController] = []) -> PageViewController {
        let sut = PageViewController(transitionStyle: .scroll, pages: pages)
        sut.loadViewIfNeeded()
        return sut
    }
    
    private func makePages(count: Int) -> [UIViewController] {
        Array(repeating: UIViewController(), count: count)
    }
}

fileprivate extension UIPageViewController {
    
    func controllerAfter(_ controller: UIViewController) -> UIViewController? {
        dataSource?.pageViewController(self, viewControllerAfter: controller)
    }
    
    func controllerBefore(_ controller: UIViewController) -> UIViewController? {
        dataSource?.pageViewController(self, viewControllerBefore: controller)
    }
}
