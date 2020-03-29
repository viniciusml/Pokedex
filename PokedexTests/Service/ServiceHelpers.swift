//
//  ServiceHelpers.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 28/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest
import Pokedex

extension XCTestCase {
    
    func makeSUT() -> (sut: RemoteLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteLoader(client: client)
        return (sut, client)
    }
    
    func baseURL(_ offset: String? = nil) -> String {
        if let offset = offset {
            return "https://pokeapi.co/api/v2/pokemon/?offset=\(offset)&limit=20"
        } else {
            return "https://pokeapi.co/api/v2/pokemon/"
        }
    }
}
