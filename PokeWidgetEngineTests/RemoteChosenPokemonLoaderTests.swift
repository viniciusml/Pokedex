//
//  RemoteChosenPokemonLoaderTests.swift
//  PokeWidgetEngineTests
//
//  Created by Vinicius Moreira Leal on 31/01/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import PokemonDomain
@testable import PokeWidgetEngine // TODO remove this
import XCTest

class RemoteChosenPokemonLoaderTests: XCTestCase {
    var client: HTTPClient!
    var listLoader: RemoteListLoaderSpy!
    var pokemonLoader: RemotePokemonLoaderSpy!
    var imageDataLoader: RemoteImageDataLoaderSpy!
    
    override func setUp() {
        super.setUp()
        
        client = HTTPClientMock()
        listLoader = RemoteListLoaderSpy(client: client)
        pokemonLoader = RemotePokemonLoaderSpy(client: client)
        imageDataLoader = RemoteImageDataLoaderSpy(client: client)
    }
    
    func test_load_producesCombinedSuccessfulResult() throws {
        let sut = makeSUT()
        
        let expectedResult = getResult(sut, when: {
            listLoader.completeListLoading(with: makeList(count: 20))
            pokemonLoader.completeItemLoading(with: makeItem(id: 2))
            imageDataLoader.completeItemLoading(with: .nonEmptyData)
        })
        
        let result = try XCTUnwrap(try expectedResult?.get())
        XCTAssertEqual(result.id, 2)
        XCTAssertEqual(result.name, "bulbasaur")
        XCTAssertEqual(String(data: result.imageData, encoding: .utf8), "test data")
    }
    
    func test_load_producesCombinedSuccessfulResultWithFallbackImageURL() throws {
        let sut = makeSUT()
        
        let expectedResult = getResult(sut, when: {
            listLoader.completeListLoading(with: makeList(count: 20))
            pokemonLoader.completeItemLoading(with: makeItem(id: 2, frontDefaultURL: false, fallbackURL: true))
            imageDataLoader.completeItemLoading(with: .nonEmptyData)
        })
        
        let result = try XCTUnwrap(try expectedResult?.get())
        XCTAssertEqual(result.id, 2)
        XCTAssertEqual(result.name, "bulbasaur")
        XCTAssertEqual(String(data: result.imageData, encoding: .utf8), "test data")
    }
    
    func test_load_producesPartialResultWithImageDataLoadingFailure() throws {
        let sut = makeSUT()
        
        let expectedResult = getResult(sut, when: {
            listLoader.completeListLoading(with: makeList(count: 20))
            pokemonLoader.completeItemLoading(with: makeItem(id: 2))
            imageDataLoader.completeItemLoadingWithError()
        })
        
        let result = try XCTUnwrap(try expectedResult?.get())
        XCTAssertEqual(result.id, 2)
        XCTAssertEqual(result.name, "bulbasaur")
        XCTAssertTrue(result.imageData.isEmpty)
    }
    
    func test_load_producesPartialResultWithInvalidURLImageDataLoading() throws {
        let sut = makeSUT()
        
        let expectedResult = getResult(sut, when: {
            listLoader.completeListLoading(with: makeList(count: 20))
            pokemonLoader.completeItemLoading(with: makeItem(id: 2, frontDefaultURL: false, fallbackURL: false))
        })
        
        let result = try XCTUnwrap(try expectedResult?.get())
        XCTAssertEqual(result.id, 2)
        XCTAssertEqual(result.name, "bulbasaur")
        XCTAssertTrue(result.imageData.isEmpty)
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
            imageDataLoader: imageDataLoader,
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

private extension Data {
    static var nonEmptyData: Data {
        Data("test data".utf8)
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

class RemoteImageDataLoaderSpy: RemoteImageDataLoader {
    private var messages = [(url: URL, completion: (RemoteLoader<Data>.Result) -> Void)]()
    
    var loadCallCount: Int {
        messages.count
    }
    
    var url: URL? {
        messages.first?.url
    }
    
    override func load(from url: URL, completion: @escaping (RemoteLoader<Data>.Result) -> Void) {
        messages.append((url, completion))
    }
    
    func completeItemLoading(with imageData: Data, at index: Int = 0) {
        messages[index].completion(.success(imageData))
    }
    
    func completeItemLoadingWithError(at index: Int = 0) {
        messages[index].completion(.failure(.connectivity))
    }
}
