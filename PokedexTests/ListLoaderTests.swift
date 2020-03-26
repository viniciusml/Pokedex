//
//  ListLoaderTests.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 26/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest
import Pokedex

class ListLoader {
    let client: NetworkAdapter
    let url: URL
    
    init(url: URL, client: NetworkAdapter) {
        self.client = client
        self.url = url
    }
    
    func loadResourceList() {
        client.load(from: url) { _ in }
    }
}

class HTTPClient {
    var requestedURL: URL?
    
    func load() {
        
    }
}

class ListLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
        let (_, client) = makeSUT(url: url)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
        let (sut, client) = makeSUT(url: url)
        
        sut.loadResourceList()
        
        XCTAssertNotNil(client.requestedURL)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://pokeapi.co/api/v2/pokemon/")!) -> (sut: ListLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = ListLoader(url: url, client: client)
        return (sut, client)
    }
    
    private class HTTPClientSpy: NetworkAdapter {

        var requestedURL: URL?
        
        func load(from url: URL, completion: @escaping (RequestResult) -> Void) {
            requestedURL = url
        }
    }
}
