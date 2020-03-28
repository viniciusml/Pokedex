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
}
