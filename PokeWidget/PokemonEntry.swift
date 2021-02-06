//
//  PokemonEntry.swift
//  PokeWidgetExtension
//
//  Created by Vinicius Moreira Leal on 06/02/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import PokemonDomain
import WidgetKit

struct PokemonEntry: TimelineEntry {
    let date: Date
    let pokemon: ChosenPokemon
}
