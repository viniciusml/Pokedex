//
//  RemoteLoaderEndToEndTests.swift
//  PokedexEndToEndTests
//
//  Created by Vinicius Moreira Leal on 29/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest
import Pokedex
import PokemonDomain

class RemoteLoaderEndToEndTests: XCTestCase {
    
    func test_endToEndLoadResourceList_matchesFixedTestData() {
        let client = AFHTTPClient(sessionConfiguration: URLSessionConfiguration.ephemeral)
        let loader = RemoteListLoader(client: client)
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=40")!

        let exp = expectation(description: "Wait for load completion")

        var receivedResult: RemoteListLoader.Result?
        loader.load(from: url) { result in
            receivedResult = result
            exp.fulfill()
        }

        wait(for: [exp], timeout: 5.0)

        switch receivedResult {
        case let .success(item):
            XCTAssertEqual(item.next, "https://pokeapi.co/api/v2/pokemon/?offset=40&limit=40")
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
                                          ResultItem(name: "raticate", url: "https://pokeapi.co/api/v2/pokemon/20/"),
                                          ResultItem(name: "spearow", url: "https://pokeapi.co/api/v2/pokemon/21/"),
                                          ResultItem(name: "fearow", url: "https://pokeapi.co/api/v2/pokemon/22/"),
                                          ResultItem(name: "ekans", url: "https://pokeapi.co/api/v2/pokemon/23/"),
                                          ResultItem(name: "arbok", url: "https://pokeapi.co/api/v2/pokemon/24/"),
                                          ResultItem(name: "pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/"),
                                          ResultItem(name: "raichu", url: "https://pokeapi.co/api/v2/pokemon/26/"),
                                          ResultItem(name: "sandshrew", url: "https://pokeapi.co/api/v2/pokemon/27/"),
                                          ResultItem(name: "sandslash", url: "https://pokeapi.co/api/v2/pokemon/28/"),
                                          ResultItem(name: "nidoran-f", url: "https://pokeapi.co/api/v2/pokemon/29/"),
                                          ResultItem(name: "nidorina", url: "https://pokeapi.co/api/v2/pokemon/30/"),
                                          ResultItem(name: "nidoqueen", url: "https://pokeapi.co/api/v2/pokemon/31/"),
                                          ResultItem(name: "nidoran-m", url: "https://pokeapi.co/api/v2/pokemon/32/"),
                                          ResultItem(name: "nidorino", url: "https://pokeapi.co/api/v2/pokemon/33/"),
                                          ResultItem(name: "nidoking", url: "https://pokeapi.co/api/v2/pokemon/34/"),
                                          ResultItem(name: "clefairy", url: "https://pokeapi.co/api/v2/pokemon/35/"),
                                          ResultItem(name: "clefable", url: "https://pokeapi.co/api/v2/pokemon/36/"),
                                          ResultItem(name: "vulpix", url: "https://pokeapi.co/api/v2/pokemon/37/"),
                                          ResultItem(name: "ninetales", url: "https://pokeapi.co/api/v2/pokemon/38/"),
                                          ResultItem(name: "jigglypuff", url: "https://pokeapi.co/api/v2/pokemon/39/"),
                                          ResultItem(name: "wigglytuff", url: "https://pokeapi.co/api/v2/pokemon/40/")])

        case let .failure(error):
            XCTFail("Expected successful list result, got \(error) instead")

        default:
            XCTFail("Expected successful list result, got no instead")
        }
    }
    
    func test_endToEndLoadPokemon_matchesFixedTestData() {
        let client = AFHTTPClient()
        let loader = RemotePokemonLoader(client: client)
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/1")!
        
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: RemotePokemonLoader.Result?
        loader.load(from: url) { result in
            receivedResult = result
            exp.fulfill()
        }

        wait(for: [exp], timeout: 5.0)

        switch receivedResult {
        case let .success(item):
            XCTAssertEqual(item.id, 1)
            XCTAssertEqual(item.baseExperience, 64)
            XCTAssertEqual(item.height, 7)
            XCTAssertEqual(item.isDefault, true)
            XCTAssertEqual(item.weight, 69)

        case let .failure(error):
            XCTFail("Expected successful pokemon result, got \(error) instead")

        default:
            XCTFail("Expected successful pokemon result, got no instead")
        }
    }
    
}

