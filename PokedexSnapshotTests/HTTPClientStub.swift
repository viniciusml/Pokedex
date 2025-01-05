//
//  HTTPClientStub.swift
//  PokedexSnapshotTests
//
//  Created by Vinicius Moreira Leal on 06/02/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import Foundation
import PokemonDomain

final class HTTPClientStub: HTTPClient {
    enum State {
        case online([Data]), offline, loading
    }
    
    let state: State
    
    init(_ state: State) {
        self.state = state
    }
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        switch state {
        case let .online(data):
            data.forEach { completion(.success(($0, makeResponse()))) }
        case .offline:
            completion(.failure(anyNSError()))
        case .loading:
            return
        }
    }
    
    private func makeResponse() -> HTTPURLResponse {
        HTTPURLResponse(url: URL(string: "http://next-url.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    func anyNSError() -> NSError {
        NSError(domain: "any error", code: 0)
    }
}
