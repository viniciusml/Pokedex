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
    
    func test_viewDidLoad_rendersResourceList() {
        let sut = ResourceListCollectionViewController()
        
        _ = sut.view
        
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), sut.listViewModel.resources.count)
    }
}
