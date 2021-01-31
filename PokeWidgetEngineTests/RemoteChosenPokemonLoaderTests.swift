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
        
        listLoader.completeListLoading(with: makeList(count: 20))
        pokemonLoader.completeItemLoading(with: makeItem(id: 2))
        
        wait(for: [exp], timeout: 0.1)
        XCTAssertEqual(try expectedResult?.get(), ChosenPokemon(id: 2, name: "bulbasaur"))
    }
    
    func test_load_failsUponListLoadingFailure() {
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
        
        listLoader.completeListLoadingWithError()
        
        wait(for: [exp], timeout: 0.1)
        XCTAssertEqual(expectedResult?.error as? RemoteLoader<ListItem>.Error, .connectivity)
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

private extension Result {
    var error: Failure? {
        switch self {
        case let .failure(error):
            return error
        case .success: return nil
        }
    }
}
