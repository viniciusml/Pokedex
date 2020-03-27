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
    
    private let itemJSON: [String: Any?] = [
        "count": 964,
        "next": "https://pokeapi.co/api/v2/pokemon/?offset=20&limit=20",
        "previous": nil,
        "results": [
            [
                "name": "bulbasaur",
                "url": "https://pokeapi.co/api/v2/pokemon/1/"
            ]
        ]
    ]
    
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
        
        expect(sut, toCompleteWith: .failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 400, 300, 500]

        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData), when: {
                let jsonData = try! JSONSerialization.data(withJSONObject: itemJSON)
                client.complete(withStatusCode: code, data: jsonData, at: index)
            })
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .failure(.invalidData), when: {
            let invalidJSON = Data("Invalid Json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_load_deliversItemsOn200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let item = ListItem(count: 964, next: "https://pokeapi.co/api/v2/pokemon/?offset=20&limit=20", previous: nil, results: [ResultItem(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/")])

        expect(sut, toCompleteWith: .success(item), when: {
            let jsonData = try! JSONSerialization.data(withJSONObject: itemJSON)
            client.complete(withStatusCode: 200, data: jsonData)
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://pokeapi.co/api/v2/pokemon/")!) -> (sut: RemoteLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteLoader(url: url, client: client)
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteLoader, toCompleteWith result: RemoteLoader.RequestResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        var capturedErrors = [RemoteLoader.RequestResult]()
        sut.loadResourceList { capturedErrors.append($0) }

        action()

        XCTAssertEqual(capturedErrors, [result], file: file, line: line)
    }
    
    private class HTTPClientSpy: NetworkAdapter {

        private var messages = [(url: URL, completion: (HTTPResult) -> Void)]()
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func load(from url: URL, completion: @escaping (HTTPResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)!
            messages[index].completion(.success((data, response)))
        }
    }
}
