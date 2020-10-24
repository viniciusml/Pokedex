//
//  ListLoaderTests.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 26/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest
import Pokedex

//class LoadResourceListRequestTests: XCTestCase {
//
//    let item = ListItem(count: 964, next: "https://pokeapi.co/api/v2/pokemon/?offset=20&limit=20", previous: nil, results: [ResultItem(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/")])
//    
//    func test_init_doesNotRequestDataFromURL() {
//        let (_, client) = makeSUT()
//        
//        XCTAssertTrue(client.requestedURLs.isEmpty)
//    }
//    
//    func test_load_requestDataFromURL() {
//        let (sut, client) = makeSUT()
//        
//        sut.loadResourceList() { _ in }
//        
//        XCTAssertEqual(client.requestedURLs, [baseURL("0")])
//    }
//    
//    func test_loadsTwice_requestsDataFromURLTwice() {
//        let url = baseURL("0")
//        let (sut, client) = makeSUT()
//        
//        sut.loadResourceList() { _ in }
//        sut.loadResourceList() { _ in }
//        
//        XCTAssertEqual(client.requestedURLs, [url, url])
//    }
//    
//    func test_load_deliversErrorOnClientError() {
//        let (sut, client) = makeSUT()
//        
//        expect(sut, toCompleteWith: .failure(.connectivity), when: {
//            let clientError: NetworkError = .connectivity
//            client.complete(with: clientError)
//        })
//    }
//    
//    func test_load_deliversItemsOn200HTTPResponse() {
//        let (sut, client) = makeSUT()
//
//        expect(sut, toCompleteWith: .success(item), when: {
//            client.complete(withValue: item)
//        })
//    }
//    
//    func test_load_usesPageParameter() {
//        let (sut, client) = makeSUT()
//        let page = "20"
//        
//        sut.loadResourceList(page: page) { _ in }
//        
//        XCTAssertEqual(client.requestedURLs, [baseURL("20")])
//    }
//    
//    // MARK: - Helpers
//    
//    private func expect(_ sut: RemoteLoader, toCompleteWith result: RequestResult<ListItem>, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
//        var capturedResult = [RequestResult<ListItem>]()
//        sut.loadResourceList { capturedResult.append($0) }
//
//        action()
//
//        XCTAssertEqual(capturedResult, [result], file: file, line: line)
//    }
//
//    func makeSUT() -> (sut: RemoteLoader, client: HTTPClientSpy<ListItem>) {
//        let client = HTTPClientSpy<ListItem>()
//        let sut = RemoteLoader(client: client)
//        return (sut, client)
//    }
//}
