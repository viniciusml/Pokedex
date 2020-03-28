//
//  LoadPokemonRequestTests.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 28/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest
import Pokedex

class LoadPokemonRequestTests: XCTestCase {
    
    func test_load_requestDataFromURL() {
        let url = "https://pokeapi.co/api/v2/pokemon/"
        let (sut, client) = makeSUT()
        
        sut.loadPokemon() { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
}
