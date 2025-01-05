//
//  RemoteChosenPokemonLoaderEndToEndTests.swift
//  PokedexEndToEndTests
//
//  Created by Vinicius Moreira Leal on 03/02/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import PokemonDomain
import XCTest

final class RemoteChosenPokemonLoaderEndToEndTests: XCTestCase {
    
    func test_endToEndLoadChosenPokemon_matchesFixedTestData() {
        let client = AFHTTPClient(sessionConfiguration: URLSessionConfiguration.ephemeral)
        
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
        
        var receivedResult: ChosenPokemon?
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
        
        switch receivedResult {
        case let .some(item):
            XCTAssertEqual(item.name, "diglett")
            XCTAssertEqual(item.id, 50)
            XCTAssertNotNil(item.imageData)
            
        case .none:
            XCTFail("Expected successful pokemon result, got none instead")
        }
    }
}
