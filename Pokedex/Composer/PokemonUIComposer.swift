//
//  PokemonUIComposer.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 07/12/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

public final class PokemonUIComposer {
    private init() {}
    
    public static func pokemonComposedWith(pokemonLoader: RemotePokemonLoader, urlString: String) -> PokemonViewController {
        let viewModel = PokemonViewModel(loader: pokemonLoader, pokemonURLString: urlString)
        let pokemonViewController = PokemonViewController(viewModel: viewModel)
        return pokemonViewController
    }
}
