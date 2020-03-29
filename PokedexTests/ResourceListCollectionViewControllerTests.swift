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
    
//    func test_resourceSelected_notifiesDelegate() {
//        let expectedID = "3"
//        let sut = ResourceListCollectionViewController()
//        let viewModel = ListViewModel(delegate: sut)
//        viewModel.resources = makeViewModelResources()
//        
//        sut.listViewModel = viewModel
//        
//        sut.collectionView.delegate?.collectionView?(sut.collectionView, didSelectItemAt: IndexPath(item: 2, section: 0))
//        
//        XCTAssertEqual(sut.selectedID, expectedID)
//    }
    
    // MARK: - Helpers
    
    func makeViewModelResources() -> [ResultItem] {
        return [ResultItem(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"),
                ResultItem(name: "ivysaur", url: "https://pokeapi.co/api/v2/pokemon/2/"),
                ResultItem(name: "venusaur", url: "https://pokeapi.co/api/v2/pokemon/3/"),
                ResultItem(name: "charmander", url: "https://pokeapi.co/api/v2/pokemon/4/"),
                ResultItem(name: "charmeleon", url: "https://pokeapi.co/api/v2/pokemon/5/"),
                ResultItem(name: "charizard", url: "https://pokeapi.co/api/v2/pokemon/6/"),
                ResultItem(name: "squirtle", url: "https://pokeapi.co/api/v2/pokemon/7/"),
                ResultItem(name: "wartortle", url: "https://pokeapi.co/api/v2/pokemon/8/"),
                ResultItem(name: "blastoise", url: "https://pokeapi.co/api/v2/pokemon/9/"),
                ResultItem(name: "caterpie", url: "https://pokeapi.co/api/v2/pokemon/10/"),
                ResultItem(name: "metapod", url: "https://pokeapi.co/api/v2/pokemon/11/"),
                ResultItem(name: "butterfree", url: "https://pokeapi.co/api/v2/pokemon/12/"),
                ResultItem(name: "weedle", url: "https://pokeapi.co/api/v2/pokemon/13/"),
                ResultItem(name: "kakuna", url: "https://pokeapi.co/api/v2/pokemon/14/"),
                ResultItem(name: "beedrill", url: "https://pokeapi.co/api/v2/pokemon/15/"),
                ResultItem(name: "pidgey", url: "https://pokeapi.co/api/v2/pokemon/16/"),
                ResultItem(name: "pidgeotto", url: "https://pokeapi.co/api/v2/pokemon/17/"),
                ResultItem(name: "pidgeot", url: "https://pokeapi.co/api/v2/pokemon/18/"),
                ResultItem(name: "rattata", url: "https://pokeapi.co/api/v2/pokemon/19/"),
                ResultItem(name: "raticate", url: "https://pokeapi.co/api/v2/pokemon/20/")]
    }
}
