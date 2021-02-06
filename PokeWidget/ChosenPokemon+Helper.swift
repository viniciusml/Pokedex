//
//  ChosenPokemon+Helper.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 06/02/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import PokemonDomain

extension ChosenPokemon {
    static var placeholder: ChosenPokemon {
        ChosenPokemon(id: 1, name: "What's that Pokémon?", imageData: .init())
    }
    
    static var failed: ChosenPokemon {
        ChosenPokemon(id: 1, name: "No Pokémon found", imageData: .init())
    }
}
