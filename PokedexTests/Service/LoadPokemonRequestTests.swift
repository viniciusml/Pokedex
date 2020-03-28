//
//  LoadPokemonRequestTests.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 28/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest
import Pokedex

class LoadPokemonRequestTests: XCTestCase {
    
    private let itemJSON: [String: Any] =
        [
            "abilities": [
                [
                    "ability": [
                        "name": "chlorophyll",
                        "url": "https://pokeapi.co/api/v2/ability/34/"
                    ],
                    "is_hidden": true,
                    "slot": 3
                ]],
            "base_experience": 64,
            "forms": [
                [
                    "name": "bulbasaur",
                    "url": "https://pokeapi.co/api/v2/pokemon-form/1/"
                ]
            ],
            "game_indices": [
                [
                    "game_index": 1,
                    "version": [
                        "name": "white-2",
                        "url": "https://pokeapi.co/api/v2/version/22/"
                    ]
                ]],
            "height": 7,
            "held_items": [],
            "id": 1,
            "is_default": true,
            "location_area_encounters": "https://pokeapi.co/api/v2/pokemon/1/encounters",
            "moves": [
                [
                    "move": [
                        "name": "razor-wind",
                        "url": "https://pokeapi.co/api/v2/move/13/"
                    ],
                    "version_group_details": [
                        [
                            "level_learned_at": 0,
                            "move_learn_method": [
                                "name": "egg",
                                "url": "https://pokeapi.co/api/v2/move-learn-method/2/"
                            ],
                            "version_group": [
                                "name": "crystal",
                                "url": "https://pokeapi.co/api/v2/version-group/4/"
                            ]
                        ],
                        [
                            "level_learned_at": 0,
                            "move_learn_method": [
                                "name": "egg",
                                "url": "https://pokeapi.co/api/v2/move-learn-method/2/"
                            ],
                            "version_group": [
                                "name": "gold-silver",
                                "url": "https://pokeapi.co/api/v2/version-group/3/"
                            ]
                        ]
                    ]
                ],
            ],
            "name": "bulbasaur",
            "order": 1,
            "species": [
                "name": "bulbasaur",
                "url": "https://pokeapi.co/api/v2/pokemon-species/1/"
            ],
            "sprites": [
                "back_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png",
                "back_female": nil,
                "back_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/1.png",
                "back_shiny_female": nil,
                "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
                "front_female": nil,
                "front_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/1.png",
                "front_shiny_female": nil
            ],
            "stats": [
                [
                    "base_stat": 45,
                    "effort": 0,
                    "stat": [
                        "name": "speed",
                        "url": "https://pokeapi.co/api/v2/stat/6/"
                    ]
                ]],
            "types": [
                [
                    "slot": 2,
                    "type": [
                        "name": "poison",
                        "url": "https://pokeapi.co/api/v2/type/4/"
                    ]
                ]
            ],
            "weight": 69
    ]
    
    private let item = PokemonItem(id: 1,
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
    
    func test_load_requestDataFromURL() {
        let (sut, client) = makeSUT()
        
        sut.loadPokemon() { _ in }
        
        XCTAssertEqual(client.requestedURLs, [baseURL()])
    }
    
    func test_load_deliversItemsOn200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .success(item), when: {
            let jsonData = try! JSONSerialization.data(withJSONObject: itemJSON)
            client.complete(withStatusCode: 200, data: jsonData)
        })
    }
    
    // MARK: - Helpers
    
    private func expect(_ sut: RemoteLoader, toCompleteWith result: RemoteLoader.RequestResult<PokemonItem>, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        var capturedResult = [RemoteLoader.RequestResult<PokemonItem>]()
        sut.loadPokemon { capturedResult.append($0) }
        
        action()
        
        XCTAssertEqual(capturedResult, [result], file: file, line: line)
    }
}
