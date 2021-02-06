//
//  Data+Helpers.swift
//  PokedexSnapshotTests
//
//  Created by Vinicius Moreira Leal on 06/02/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

extension Data {
    static var listData: Data {
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
    
    static var pokemonData: Data {
        let json = [
            "id": 1,
            "name": "bulbasaur",
            "base_experience": 64,
            "height": 7,
            "is_default": true,
            "order": 1,
            "weight": 69,
            "abilities": [[
                            "is_hidden": true,
                            "slot": 3,
                            "ability": ["name": "chlorophyll",
                                        "url": "https://pokeapi.co/api/v2/ability/34/"]]],
            "forms": [["name": "bulbasaur",
                       "url": "https://pokeapi.co/api/v2/pokemon-form/1/"]],
            "species": ["name": "bulbasaur",
                        "url": "https://pokeapi.co/api/v2/pokemon-species/1/"],
            "sprites": ["back_female": nil,
                        "back_shiny_female": nil,
                        "back_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png",
                        "front_female": nil,
                        "front_shiny_female": nil,
                        "back_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/1.png",
                        "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
                        "front_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/1.png"],
            "stats": [["base_stat": 45,
                       "effort": 0,
                       "stat": ["name": "speed",
                                "url": "https://pokeapi.co/api/v2/stat/6/"]]],
            "types": [["slot": 2,
                       "type": ["name": "poison",
                                "url": "https://pokeapi.co/api/v2/type/4/"]]]
        ].compactMapValues { $0 }
        
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    static var pokemonImageData: Data {
        UIImage.makeImageData()
    }
    
    static var pokemonInvalidImageData: Data {
        Data("any data".utf8)
    }
}
