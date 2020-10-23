//
//  HTTPClientSpy.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 28/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation
import Pokedex

class HTTPClientSpy<U: Decodable>: HTTPClient {

    private var messages = [(url: String, completion: (RequestResult<U>) -> Void)]()

    var requestedURLs: [String] {
        return messages.map { $0.url }
    }

    func load<T: Decodable>(_ object: T.Type, from url: String, completion: @escaping (RequestResult<T>) -> Void) {
        if T.self is U.Type {
            messages.append((url, completion as! (Result<U, NetworkError>) -> Void))
        }
    }
    
    func complete(with error: NetworkError, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }
    
    func complete(withValue value: U, at index: Int = 0) {
        messages[index].completion(.success(value))
    }
}
