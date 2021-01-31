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
    var client: HTTPClient!
    var listLoader: RemoteListLoaderSpy!
    var pokemonLoader: RemotePokemonLoaderSpy!
    
    override func setUp() {
        super.setUp()
        
        client = HTTPClientMock()
        listLoader = RemoteListLoaderSpy(client: client)
        pokemonLoader = RemotePokemonLoaderSpy(client: client)
    }
    
    func test_load_producesCombinedSuccessfulResult() {
        let sut = makeSUT()
        
        let expectedResult = getResult(sut, when: {
            listLoader.completeListLoading(with: makeList(count: 20))
            pokemonLoader.completeItemLoading(with: makeItem(id: 2))
        })
        
        XCTAssertEqual(try expectedResult?.get(), ChosenPokemon(id: 2, name: "bulbasaur"))
    }
    
    func test_load_failsUponListLoadingFailure() {
        let sut = makeSUT()
        
        let expectedResult = getResult(sut, when: {
            listLoader.completeListLoadingWithError()
        })
        
        XCTAssertEqual(expectedResult?.error as? RemoteLoader<ListItem>.Error, .connectivity)
    }
    
    func test_load_failsUponPokemonLoadingFailure() {
        let sut = makeSUT()
        
        let expectedResult = getResult(sut, when: {
            listLoader.completeListLoading(with: makeList(count: 20))
            pokemonLoader.completeItemLoadingWithError()
        })
        
        XCTAssertEqual(expectedResult?.error as? RemoteLoader<PokemonItem>.Error, .connectivity)
    }
    
    // MARK: Helpers
    
    private func makeSUT(withGeneratedID id: Int = 1) -> RemoteChosenPokemonLoader {
        let idProvider = IDProviderStub(withStubbedID: 1)
        return RemoteChosenPokemonLoader(
            listLoader: listLoader,
            pokemonLoader: pokemonLoader,
            idProvider: idProvider)
    }
    
    private func getResult(_ sut: RemoteChosenPokemonLoader, when action: () -> Void) -> RemoteChosenPokemonLoader.Result? {
        let exp = expectation(description: "wait for result")
        var result: Result<ChosenPokemon, Error>?
        sut.load {
            result = $0
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 0.1)
        return result
    }
    
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
