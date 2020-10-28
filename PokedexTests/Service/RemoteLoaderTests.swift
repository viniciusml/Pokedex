//
//  RemoteLoaderTests.swift
//  PokedexTests
//
//  Created by Vinicius Leal on 23/10/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Pokedex
import XCTest

class RemoteLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT()
        
        sut.load(from: url) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT()
        
        sut.load(from: url) { _ in }
        sut.load(from: url) { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }
    
    func test_load_deliversErrorOnMapperError() {
        let (sut, client) = makeSUT(mapper: { _ in
            throw anyNSError()
        })
        
        expect(sut, toCompleteWith: failure(.invalidData), when: {
            client.complete(withStatusCode: 200, data: anyData())
        })
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() throws {
        let (sut, client) = makeSUT()
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: failure(.invalidData), when: {
                client.complete(withStatusCode: code, data: anyData(), at: index)
            })
        }
    }
    
    func test_load_deliversMappedResource() {
        let resource = "a resource"
        let (sut, client) = makeSUT(mapper: { data in
            String(data: data, encoding: .utf8)!
        })
        
        expect(sut, toCompleteWith: .success(resource), when: {
            client.complete(withStatusCode: 200, data: Data(resource.utf8))
        })
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        var sut: RemoteLoader<String>? = RemoteLoader<String>(client: client, mapper: { _ in "any" })
        
        var capturedResults = [RemoteLoader<String>.Result]()
        sut?.load(from: url) { capturedResults.append($0) }
        
        sut = nil
        client.complete(withStatusCode: 200, data: anyData())
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        mapper: @escaping RemoteLoader<String>.Mapper = { _ in "any" },
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: RemoteLoader<String>, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteLoader<String>(client: client, mapper: mapper)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    private func failure(_ error: RemoteLoader<String>.Error) -> RemoteLoader<String>.Result {
        .failure(error)
    }
    
    private func expect(_ sut: RemoteLoader<String>, toCompleteWith expectedResult: RemoteLoader<String>.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load(from: anyURL()) { receivedResult in
            switch (receivedResult, expectedResult) {
                case let (.success(receivedItems), .success(expectedItems)):
                    XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
                    
                case let (.failure(receivedError as RemoteLoader<String>.Error), .failure(expectedError as RemoteLoader<String>.Error)):
                    XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                    
                default:
                    XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
}
