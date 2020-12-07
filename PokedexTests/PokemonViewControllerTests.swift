//
//  PokemonViewControllerTests.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 07/12/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Pokedex
import XCTest

class PokemonViewControllerTests: XCTestCase {
    
    func test_loadActions_requestsItemFromLoader() {
        let (sut, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading requests before the view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadCallCount, 1, "Expected a loading request once the view is loaded")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: PokemonViewController, loader: RemotePokemonLoaderSpy) {
        let client = HTTPClientSpy()
        let loader = RemotePokemonLoaderSpy(client: client)
        let viewModel = PokemonViewModel(loader: loader, pokemonID: "3")
        let sut = PokemonViewController(viewModel: viewModel)
        
        return (sut, loader)
    }
}
