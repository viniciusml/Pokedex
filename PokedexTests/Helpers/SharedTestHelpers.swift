//
//  SharedTestHelpers.swift
//  PokedexTests
//
//  Created by Vinicius Leal on 24/10/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation
import PokemonDomain

func anyData() -> Data {
    Data("any data".utf8)
}

func anyURL() -> URL {
    URL(string: "http://any-url.com")!
}

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}

func makeItemsJSON(_ items: [String: Any]) -> Data {
    try! JSONSerialization.data(withJSONObject: items)
}

func makeList(count: Int, next: String = "http://pokemon-url.com", previous: String? = nil, results: [ResultItem] = []) -> ListItem {
    ListItem(count: 3, next: "http://pokemon-url.com", previous: previous, results: results)
}

func makeItem(id: Int, frontDefaultURL: Bool = true, fallbackURL: Bool = true) -> PokemonItem {
    let backDefault = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png"
    let backShiny = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/1.png"
    let frontDefault = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"
    let frontShiny = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/1.png"
    
    return PokemonItem(id: id,
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
                                 backDefault: fallbackURL ? backDefault : nil,
                                 frontFemale: nil,
                                 frontShinyFemale: nil,
                                 backShiny: fallbackURL ? backShiny : nil,
                                 frontDefault: frontDefaultURL ? frontDefault : nil,
                                 frontShiny: fallbackURL ? frontShiny : nil),
                stats: [Stat(baseStat: 45,
                             effort: 0,
                             stat: Species(name: "speed",
                                           url: "https://pokeapi.co/api/v2/stat/6/"))],
                types: [TypeElement(slot: 2,
                                    type: Species(name: "poison",
                                                  url: "https://pokeapi.co/api/v2/type/4/"))])
}
