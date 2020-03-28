//
//  PokemonItem.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 25/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

// MARK: - Pokemon Item
public struct PokemonItem: Decodable, Equatable {
    let id: Int
    let name: String
    let baseExperience, height: Int
    let isDefault: Bool
    let order, weight: Int
    let abilities: [Ability]
    let forms: [Species]
    let species: Species
    let sprites: Sprites
    let stats: [Stat]
    let types: [TypeElement]
    
    public init(id: Int, name: String, baseExperience: Int, height: Int, isDefault: Bool, order: Int, weight: Int, abilities: [Ability], forms: [Species], species: Species, sprites: Sprites, stats: [Stat], types: [TypeElement]) {
        self.id = id
        self.name = name
        self.baseExperience = baseExperience
        self.height = height
        self.isDefault = isDefault
        self.order = order
        self.weight = weight
        self.abilities = abilities
        self.forms = forms
        self.species = species
        self.sprites = sprites
        self.stats = stats
        self.types = types
    }

    enum CodingKeys: String, CodingKey {
        case id, name
        case baseExperience = "base_experience"
        case height
        case isDefault = "is_default"
        case order, weight, abilities, forms
        case species, sprites, stats, types
    }
}

// MARK: - Ability
public struct Ability: Decodable, Equatable {
    let isHidden: Bool
    let slot: Int
    let ability: Species
    
    public init(isHidden: Bool, slot: Int, ability: Species) {
        self.isHidden = isHidden
        self.slot = slot
        self.ability = ability
    }

    enum CodingKeys: String, CodingKey {
        case isHidden = "is_hidden"
        case slot, ability
    }
}

// MARK: - Species
public struct Species: Decodable, Equatable {
    let name: String
    let url: String
    
    public init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}

// MARK: - Sprites
public struct Sprites: Decodable, Equatable {
    let backFemale, backShinyFemale, backDefault, frontFemale: String?
    let frontShinyFemale, backShiny, frontDefault, frontShiny: String?
    
    public init(backFemale: String?, backShinyFemale: String?, backDefault: String?, frontFemale: String?, frontShinyFemale: String?, backShiny: String?, frontDefault: String?, frontShiny: String?) {
        self.backFemale = backFemale
        self.backShinyFemale = backShinyFemale
        self.backDefault = backDefault
        self.frontFemale = frontFemale
        self.frontShinyFemale = frontShinyFemale
        self.backShiny = backShiny
        self.frontDefault = frontDefault
        self.frontShiny = frontShiny
    }

    enum CodingKeys: String, CodingKey {
        case backFemale = "back_female"
        case backShinyFemale = "back_shiny_female"
        case backDefault = "back_default"
        case frontFemale = "front_female"
        case frontShinyFemale = "front_shiny_female"
        case backShiny = "back_shiny"
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
    }
}

// MARK: - Stat
public struct Stat: Decodable, Equatable {
    let baseStat, effort: Int
    let stat: Species

    public init(baseStat: Int, effort: Int, stat: Species) {
        self.baseStat = baseStat
        self.effort = effort
        self.stat = stat
    }
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort, stat
    }
}

// MARK: - TypeElement
public struct TypeElement: Decodable, Equatable {
    let slot: Int
    let type: Species
    
    public init(slot: Int, type: Species) {
        self.slot = slot
        self.type = type
    }
}
