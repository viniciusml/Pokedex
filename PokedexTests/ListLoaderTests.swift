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
    
    init(client: NetworkAdapter) {
        self.client = client
    }
    
    func loadResourceList() {
        client.load(from: URL(string: "http:a-given-url.com")!) { _ in }
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
        let client = HTTPClientSpy()
        _ = ListLoader(client: client)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let client = HTTPClientSpy()
        let sut = ListLoader(client: client)
        
        sut.loadResourceList()
        
        XCTAssertNotNil(client.requestedURL)
    }
}
