//
//  IDProviderStub.swift
//  PokeWidgetEngineTests
//
//  Created by Vinicius Moreira Leal on 03/02/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import PokemonDomain

struct IDProviderStub: IDProvider {
    let stubbedID: Int
    
    init(withStubbedID id: Int) {
        self.stubbedID = id
    }
    
    func generateID(upTo max: Int) -> Int { stubbedID }
}
