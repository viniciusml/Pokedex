//
//  ChosenPokemon.swift
//  PokeWidgetExtension
//
//  Created by Vinicius Moreira Leal on 24/01/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

struct ChosenPokemon {
    let totalPokemonNumber: Int
    let name: String
}

extension ChosenPokemon {
    static var placeholder: ChosenPokemon {
        ChosenPokemon(totalPokemonNumber: 1, name: "A Pokémon")
    }
}
