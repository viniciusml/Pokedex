//
//  PokedexSnapshotTests.swift
//  PokedexSnapshotTests
//
//  Created by Vinicius Moreira Leal on 10/12/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import SnapshotTesting
import Pokedex
import XCTest

class PokedexSnapshotTests: XCTestCase {

    func test_listViewController_online() {
        assertSnapshot(matching: makeSUT(.online), as: .image)
    }
    
    func test_listViewController_offline() {
        assertSnapshot(matching: makeSUT(.offline), as: .image)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(_ state: HTTPClientStub.State) -> ResourceListCollectionViewController {
        let client = HTTPClientStub(state)
        let listLoader = RemoteListLoader(client: client)
        let viewController = ResourceListUIComposer.resourceListComposedWith(listLoader: listLoader, selection: { _ in })
        return viewController
    }
    
    private class HTTPClientStub: HTTPClient {
        enum State {
            case online, offline
        }
        
        let state: State
        
        init(_ state: State) {
            self.state = state
        }
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            switch state {
                case .online:
                    completion(.success((makeData(), makeResponse())))
                case .offline:
                    completion(.failure(anyNSError()))
            }
        }
        
        private func makeData() -> Data {
            let json = [
                "count": 200,
                "next": "http://next-url.com",
                "previous": nil,
                "results": [
                    ["name": "name1",
                     "url": "http://a-url.com"],
                    ["name": "name2",
                     "url": "http://a-url.com"],
                    ["name": "name3",
                     "url": "http://a-url.com"],
                    ["name": "name4",
                     "url": "http://a-url.com"],
                    ["name": "name5",
                     "url": "http://a-url.com"],
                    ["name": "name6",
                     "url": "http://a-url.com"],
                    ["name": "name7",
                     "url": "http://a-url.com"],
                    ["name": "name8",
                     "url": "http://a-url.com"]
                ]
            ].compactMapValues { $0 }
            
            return try! JSONSerialization.data(withJSONObject: json)
        }
        
        private func makeResponse() -> HTTPURLResponse {
            HTTPURLResponse(url: URL(string: "http://next-url.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        }
        
        func anyNSError() -> NSError {
            NSError(domain: "any error", code: 0)
        }
    }
}
