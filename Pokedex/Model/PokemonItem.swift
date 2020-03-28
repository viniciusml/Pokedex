//
//  PokemonItem.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 25/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

// MARK: - Pokemon Item
public struct PokemonItem: Decodable {
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
public struct Ability: Decodable {
    let isHidden: Bool
    let slot: Int
    let ability: Species

    enum CodingKeys: String, CodingKey {
        case isHidden = "is_hidden"
        case slot, ability
    }
}

// MARK: - Species
public struct Species: Decodable {
    let name: String
    let url: String
}

// MARK: - Sprites
public struct Sprites: Decodable {
    let backFemale, backShinyFemale, backDefault, frontFemale: String
    let frontShinyFemale, backShiny, frontDefault, frontShiny: String

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
public struct Stat: Decodable {
    let baseStat, effort: Int
    let stat: Species

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort, stat
    }
}

// MARK: - TypeElement
public struct TypeElement: Decodable {
    let slot: Int
    let type: Species
}
