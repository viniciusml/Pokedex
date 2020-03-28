//
//  HTTPClientSpy.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 28/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation
import Pokedex

class HTTPClientSpy: NetworkAdapter {

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
