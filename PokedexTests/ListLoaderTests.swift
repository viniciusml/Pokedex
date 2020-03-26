//
//  ListLoaderTests.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 26/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest
import Pokedex

class ListLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
        let (_, client) = makeSUT(url: url)
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestDataFromURL() {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
        let (sut, client) = makeSUT(url: url)
        
        sut.loadResourceList()
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadsTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
        let (sut, client) = makeSUT(url: url)
        
        sut.loadResourceList()
        sut.loadResourceList()
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        client.error = NSError(domain: "Test", code: 0)
        
        var capturedError: ListLoader.Error?
        sut.loadResourceList { error in
            capturedError = error
        }
        
        XCTAssertEqual(capturedError, .connectivity)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://pokeapi.co/api/v2/pokemon/")!) -> (sut: ListLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = ListLoader(url: url, client: client)
        return (sut, client)
    }
    
    private class HTTPClientSpy: NetworkAdapter {

        var requestedURLs = [URL]()
        var error: Error?
        
        func load(from url: URL, completion: @escaping (RequestResult) -> Void) {
            if let error = error {
                completion(.failure(error))
            }
            requestedURLs.append(url)
        }
    }
}
