//
//  PokemonLoader.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 25/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

typealias PokemonResult = Result<PokemonItem, Error>

protocol PokemonLoader {
    func load(completion: @escaping (PokemonResult) -> Void)
}
