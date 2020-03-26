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

class HTTPClientSpy: NetworkAdapter {

    var requestedURL: URL?
    
    func load(from url: URL, completion: @escaping (RequestResult) -> Void) {
        requestedURL = url
    }
}

class ListLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
        let client = HTTPClientSpy()
        _ = ListLoader(url: url, client: client)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
        let client = HTTPClientSpy()
        let sut = ListLoader(url: url, client: client)
        
        sut.loadResourceList()
        
        XCTAssertNotNil(client.requestedURL)
    }
}
