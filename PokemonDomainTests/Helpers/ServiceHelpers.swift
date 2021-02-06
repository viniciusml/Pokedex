//
//  ServiceHelpers.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 28/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest

extension XCTestCase {
    
    func baseURL(_ offset: String? = nil) -> String {
        if let offset = offset {
            return "https://pokeapi.co/api/v2/pokemon/?offset=\(offset)&limit=40"
        } else {
            return "https://pokeapi.co/api/v2/pokemon/"
        }
    }
}
