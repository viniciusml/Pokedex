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
    public let id: Int
    public let name: String
    public let baseExperience, height: Int
    public let isDefault: Bool
    public let order, weight: Int
    public let abilities: [Ability]
    public let forms: [Species]
    public let species: Species
    public let sprites: Sprites
    public let stats: [Stat]
    public let types: [TypeElement]

    public init(
        id: Int, name: String, baseExperience: Int, height: Int, isDefault: Bool, order: Int, weight: Int, abilities: [Ability], forms: [Species], species: Species, sprites: Sprites,
        stats: [Stat], types: [TypeElement]
    ) {
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
    public let isHidden: Bool
    public let slot: Int
    public let ability: Species

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
    public let name: String
    public let url: String

    public init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}

// MARK: - Sprites
public struct Sprites: Decodable, Equatable {
    public let backFemale, backShinyFemale, backDefault, frontFemale: String?
    public let frontShinyFemale, backShiny, frontDefault, frontShiny: String?

    public init(
        backFemale: String?, backShinyFemale: String?, backDefault: String?, frontFemale: String?, frontShinyFemale: String?, backShiny: String?, frontDefault: String?, frontShiny: String?
    ) {
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

extension Sprites {
    public var allSprites: [String] {
        [frontDefault,
         frontFemale,
         frontShiny,
         frontShinyFemale,
         backDefault,
         backFemale,
         backShiny,
         backShinyFemale]
            .compactMap { $0 }
    }
}

// MARK: - Stat
public struct Stat: Decodable, Equatable {
    public let baseStat, effort: Int
    public let stat: Species

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
    public let slot: Int
    public let type: Species

    public init(slot: Int, type: Species) {
        self.slot = slot
        self.type = type
    }

    /// Maps the 'id' returned in the last component of the url string into a PokeType.
    /// In case the url convertion to Int fails, a default '10001' value is presented, which represents 'unkown' enum case.
    public func typeID() -> PokeType? {
        let url = URL(fileURLWithPath: type.url).pathComponents.dropFirst()
        if let id = Int(url.last ?? "10001") {
            return PokeType(rawValue: id)
        } else {
            return PokeType(rawValue: 10001)
        }
    }
}
