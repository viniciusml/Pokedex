//
//  RemoteChosenPokemonLoaderEndToEndTests.swift
//  PokedexEndToEndTests
//
//  Created by Vinicius Moreira Leal on 03/02/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import PokeWidgetEngine
import PokemonDomain
import XCTest

class RemoteChosenPokemonLoaderEndToEndTests: XCTestCase {
    
    func test_endToEndLoadChosenPokemon_matchesFixedTestData() {
        let client = AFHTTPClient()
        
        let listLoader = RemoteListLoader(client: client)
        let pokemonLoader = RemotePokemonLoader(client: client)
        let imageDataLoader = RemoteImageDataLoader(client: client)
        let idProvider = IDProviderStub(withStubbedID: 50)
        
        let loader = RemoteChosenPokemonLoader(
            listLoader: listLoader,
            pokemonLoader: pokemonLoader,
            imageDataLoader: imageDataLoader,
            idProvider: idProvider)
        
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: RemoteChosenPokemonLoader.Result?
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
        
        switch receivedResult {
        case let .success(item):
            XCTAssertEqual(item.name, "diglett")
            XCTAssertEqual(item.id, 50)
            XCTAssertNotNil(item.imageData)
            
        case let .failure(error):
            XCTFail("Expected successful list result, got \(error) instead")
            
        default:
            XCTFail("Expected successful pokemon result, got no result instead")
        }
    }
}
