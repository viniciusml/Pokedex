//
//  ListLoaderTests.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 26/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest
import Pokedex

class RemoteLoaderTests: XCTestCase {
    
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
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestDataFromURL() {
        let url = "https://pokeapi.co/api/v2/pokemon/"
        let (sut, client) = makeSUT()
        
        sut.loadResourceList() { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadsTwice_requestsDataFromURLTwice() {
        let url = "https://pokeapi.co/api/v2/pokemon/"
        let (sut, client) = makeSUT()
        
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
    
    func test_load_usesPageParameter() {
        let (sut, client) = makeSUT()
        let baseUrl = "https://pokeapi.co/api/v2/pokemon/"
        let page = "?offset=0&limit=20"
        
        sut.loadResourceList(page: page) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [baseUrl + page])
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: RemoteLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteLoader(client: client)
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteLoader, toCompleteWith result: RemoteLoader.RequestResult<ListItem>, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        var capturedResult = [RemoteLoader.RequestResult<ListItem>]()
        sut.loadResourceList { capturedResult.append($0) }

        action()

        XCTAssertEqual(capturedResult, [result], file: file, line: line)
    }
    
    private class HTTPClientSpy: NetworkAdapter {

        private var messages = [(url: String, completion: (HTTPResult) -> Void)]()
        var requestedURLs: [String] {
            return messages.map { $0.url }
        }
        
        func load(from url: String, completion: @escaping (HTTPResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(url: URL(string: requestedURLs[index])!, statusCode: code, httpVersion: nil, headerFields: nil)!
            messages[index].completion(.success((data, response)))
        }
    }
}
