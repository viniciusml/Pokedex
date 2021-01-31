//
//  RemoteChosenPokemonLoaderTests.swift
//  PokeWidgetEngineTests
//
//  Created by Vinicius Moreira Leal on 31/01/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import PokemonDomain
import PokeWidgetEngine
import XCTest

class RemoteChosenPokemonLoaderTests: XCTestCase {
    
    func test_load_producesCombinedSuccessfulResult() {
        let client = HTTPClientMock()
        let listLoader = RemoteListLoaderSpy(client: client)
        let pokemonLoader = RemotePokemonLoaderSpy(client: client)
        let idProvider = IDProviderStub(withStubbedID: 1)
        let sut = RemoteChosenPokemonLoader(
            listLoader: listLoader,
            pokemonLoader: pokemonLoader,
            idProvider: idProvider)
        
        let exp = expectation(description: "wait for result")
        var expectedResult: Result<ChosenPokemon, Error>?
        sut.load { receivedResult in
            expectedResult = receivedResult
            exp.fulfill()
        }
        
        listLoader.completeListLoading(with: ListItem(count: 20, next: "", previous: nil, results: []))
        pokemonLoader.completeItemLoading(with: PokemonItem(id: 2, name: "Bulbasaur", baseExperience: 0, height: 0, isDefault: true, order: 2, weight: 1, abilities: [], forms: [], species: Species(name: "", url: ""), sprites: Sprites(backFemale: nil, backShinyFemale: nil, backDefault: nil, frontFemale: nil, frontShinyFemale: nil, backShiny: nil, frontDefault: nil, frontShiny: nil), stats: [], types: []))
        
        wait(for: [exp], timeout: 0.1)
        XCTAssertEqual(try expectedResult?.get(), ChosenPokemon(id: 1, name: "Pokemon"))
    }
    
    // MARK: Helpers
    
    private struct IDProviderStub: IDProvider {
        let stubbedID: Int
        
        init(withStubbedID id: Int) {
            self.stubbedID = id
        }
        
        func generateID(from min: Int, to max: Int) -> Int { stubbedID }
    }
    
    private struct HTTPClientMock: HTTPClient {
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {}
    }
}

