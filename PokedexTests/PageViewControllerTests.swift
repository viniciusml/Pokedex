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
        let pages = [UIViewController()]
        let sut = makeSUT(pages: pages)
        
        XCTAssertEqual(sut.viewControllers, pages)
    }
    
    func test_viewControllerAfter_selectsNextIndex() {
        let controller1 = UIViewController()
        let controller2 = UIViewController()
        let pages = [controller1, controller2]
        
        let sut = makeSUT(pages: pages)
        let controllerAfter = sut.controllerAfter(controller1)
        
        XCTAssertEqual(controllerAfter, controller2)
    }
    
    func test_viewControllerAfterTwice_selectsSecondNextIndex() {
        let controller1 = UIViewController()
        let controller2 = UIViewController()
        let controller3 = UIViewController()
        let pages = [controller1, controller2, controller3]
        
        let sut = makeSUT(pages: pages)
        let controllerAfter = sut.controllerAfter(controller1)
        let secondControllerAfter = sut.controllerAfter(controllerAfter!)
        
        XCTAssertEqual(secondControllerAfter, controller3)
    }
    
    func test_viewControllerAfter_whenMaxNumberOfPagesReached_selectsToFirstController() {
        let controller1 = UIViewController()
        let controller2 = UIViewController()
        let pages = [controller1, controller2]
        
        let sut = makeSUT(pages: pages)
        let controllerAfter: UIViewController? = sut.controllerAfter(controller2)
        
        XCTAssertEqual(controllerAfter, controller1)
    }
    
    func test_viewControllerBefore_selectsPreviousIndex() {
        let controller1 = UIViewController()
        let controller2 = UIViewController()
        let pages = [controller1, controller2]
        
        let sut = makeSUT(pages: pages)
        let controllerBefore = sut.controllerBefore(controller2)
        
        XCTAssertEqual(controllerBefore, controller1)
    }
    
    func test_viewControllerBeforeTwice_selectsSecondPreviousIndex() {
        let controller1 = UIViewController()
        let controller2 = UIViewController()
        let controller3 = UIViewController()
        let pages = [controller1, controller2, controller3]
        
        let sut = makeSUT(pages: pages)
        let controllerBefore = sut.controllerBefore(controller3)
        let secondControllerBefore = sut.controllerBefore(controllerBefore!)
        
        XCTAssertEqual(secondControllerBefore, controller1)
    }
    
    func test_viewControllerBefore_whenInFirstPage_selectsLastController() {
        let controller1 = UIViewController()
        let controller2 = UIViewController()
        let pages = [controller1, controller2]
        
        let sut = makeSUT(pages: pages)
        let controllerBefore: UIViewController? = sut.controllerBefore(controller1)
        
        XCTAssertEqual(controllerBefore, controller2)
    }
    
    func test_presentationCount_setsCorrectNumberOfPages() {
        let controller1 = UIViewController()
        let pages = [controller1]
        
        let sut = makeSUT(pages: pages)
        let presentationCount = sut.dataSource?.presentationCount?(for: sut)
        
        XCTAssertEqual(presentationCount, pages.count)
    }
    
    func test_presentationIndex_initiatesAtFirstIndex() {
        let controller1 = UIViewController()
        let pages = [controller1]
        
        let sut = makeSUT(pages: pages)
        let presentationIndex = sut.dataSource?.presentationIndex!(for: sut)
        
        XCTAssertEqual(presentationIndex, 0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(pages: [UIViewController] = []) -> PageViewController {
        let sut = PageViewController(pages: pages)
        sut.loadViewIfNeeded()
        return sut
    }
}

fileprivate extension UIPageViewController {
    
    func controllerAfter(_ controller: UIViewController) -> UIViewController? {
        return dataSource?.pageViewController(self, viewControllerAfter: controller)
    }
    
    func controllerBefore(_ controller: UIViewController) -> UIViewController? {
        return dataSource?.pageViewController(self, viewControllerBefore: controller)
    }
}
