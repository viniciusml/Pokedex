//
//  PokemonItemMapperTests.swift
//  PokedexTests
//
//  Created by Vinicius Leal on 24/10/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest
import Pokedex

class PokemonItemMapperTests: XCTestCase {
    
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeItemsJSON([:])
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try PokemonItemMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try PokemonItemMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliversErrorOn200HTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeItemsJSON([:])
        
        XCTAssertThrowsError(
            try PokemonItemMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        let item = makeItem()
        
        let json = makeItemsJSON(item.json)
        
        let result = try PokemonItemMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, item.model)
    }
    
    // MARK: - Helpers
    
    private func makeItem() -> (model: PokemonItem, json: [String: Any]) {
        
        let item = PokemonItem(id: 1,
                               name: "bulbasaur",
                               baseExperience: 64,
                               height: 7,
                               isDefault: true,
                               order: 1,
                               weight: 69,
                               abilities: [
                                Ability(isHidden: true,
                                        slot: 3,
                                        ability: Species(name: "chlorophyll",
                                                         url: "https://pokeapi.co/api/v2/ability/34/"))],
                               forms: [Species(name: "bulbasaur",
                                               url: "https://pokeapi.co/api/v2/pokemon-form/1/")],
                               species: Species(name: "bulbasaur",
                                                url: "https://pokeapi.co/api/v2/pokemon-species/1/"),
                               sprites: Sprites(backFemale: nil,
                                                backShinyFemale: nil,
                                                backDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png",
                                                frontFemale: nil,
                                                frontShinyFemale: nil,
                                                backShiny: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/1.png",
                                                frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
                                                frontShiny: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/1.png"),
                               stats: [Stat(baseStat: 45,
                                            effort: 0,
                                            stat: Species(name: "speed",
                                                          url: "https://pokeapi.co/api/v2/stat/6/"))],
                               types: [TypeElement(slot: 2,
                                                   type: Species(name: "poison",
                                                                 url: "https://pokeapi.co/api/v2/type/4/"))])
        
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
        
        return (item, json)
    }
}
