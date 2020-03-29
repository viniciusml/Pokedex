//
//  RemoteLoaderEndToEndTests.swift
//  PokedexEndToEndTests
//
//  Created by Vinicius Moreira Leal on 29/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest
import Pokedex

class RemoteLoaderEndToEndTests: XCTestCase {
    
    func test_endToEndLoadResourceList_matchesFixedTestData() {
        let client = HTTPClient()
        let loader = RemoteLoader(client: client)

        let exp = expectation(description: "Wait for load completion")

        var receivedResult: RemoteLoader.RequestResult<ListItem>?

        loader.loadResourceList(page: "0") { result in
            receivedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)

        switch receivedResult {
        case let .success(item):
            XCTAssertEqual(item.count, 964)
            XCTAssertEqual(item.next, "https://pokeapi.co/api/v2/pokemon/?offset=20&limit=20")
            XCTAssertEqual(item.previous, nil)
            XCTAssertEqual(item.results, [ResultItem(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"),
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
                                          ResultItem(name: "raticate", url: "https://pokeapi.co/api/v2/pokemon/20/")])

        case let .failure(error):
            XCTFail("Expected successful list result, got \(error) instead")

        default:
            XCTFail("Expected successful list result, got no instead")
        }
    }
    
}
