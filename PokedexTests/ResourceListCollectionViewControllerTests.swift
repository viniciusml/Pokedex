//
//  ResourceListCollectionViewControllerTests.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 29/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest
@testable import Pokedex

class ResourceListCollectionViewControllerTests: XCTestCase {
    
    func test_viewDidLoad_registersListCollectionViewCell() {
        let sut = ResourceListCollectionViewController()
        
        let cell = sut.collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.identifier, for: IndexPath(item: 0, section: 0))
        
        // then
        XCTAssertTrue(cell is ListCell)
    }
    
    func test_viewDidLoad_rendersResourceList() {
        let sut = ResourceListCollectionViewController()
        
        _ = sut.view
        
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), sut.listViewModel.resources.count)
    }
}
