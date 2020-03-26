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
        
        sut.loadResourceList() { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadsTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
        let (sut, client) = makeSUT(url: url)
        
        sut.loadResourceList() { _ in }
        sut.loadResourceList() { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        var capturedErrors = [ListLoader.Error]()
        sut.loadResourceList { capturedErrors.append($0) }
        
        let clientError = NSError(domain: "Test", code: 0)
        client.complete(with: clientError)
        
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 400, 300, 500]

        samples.enumerated().forEach { index, code in
            var capturedErrors = [ListLoader.Error]()
            sut.loadResourceList { capturedErrors.append($0) }

            client.complete(withStatusCode: code, at: index)

            XCTAssertEqual(capturedErrors, [.invalidData])
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()

        var capturedErrors = [ListLoader.Error]()
        sut.loadResourceList { capturedErrors.append($0) }

        let invalidJSON = Data("Invalid Json".utf8)
        client.complete(withStatusCode: 200, data: invalidJSON)

        XCTAssertEqual(capturedErrors, [.invalidData])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://pokeapi.co/api/v2/pokemon/")!) -> (sut: ListLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = ListLoader(url: url, client: client)
        return (sut, client)
    }
    
    private class HTTPClientSpy: NetworkAdapter {

        private var messages = [(url: URL, completion: (RequestResult) -> Void)]()
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func load(from url: URL, completion: @escaping (RequestResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)!
            messages[index].completion(.success((data, response)))
        }
    }
}
