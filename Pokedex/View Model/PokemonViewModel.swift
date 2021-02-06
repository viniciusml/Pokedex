//
//  PokemonViewModel.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 29/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation
import PokemonDomain

public class PokemonViewModel {

    // MARK: - Properties

    private let pokemonURLString: String
    private let loader: RemotePokemonLoader
    private var fetchedPokemon: PokemonItem?
    
    var onFetchCompleted: ((PokemonViewModel) -> Void)?
    var onImageCheckCompleted: (([String]) -> Void)?
    var onFetchFailed: (() -> Void)?

    // MARK: - Initializer

    public init(loader: RemotePokemonLoader, pokemonURLString: String) {
        self.loader = loader
        self.pokemonURLString = pokemonURLString
    }

    // MARK: - API

    func fetchPokemon() {
        loader.load(from: URL(string: "\(pokemonURLString)")!) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case .success(let pokemon):
                    self.mapAvailableImages(from: pokemon.sprites)
                    self.fetchedPokemon = pokemon
                    self.onFetchCompleted?(self)
                case .failure:
                    
                    self.onFetchFailed?()
            }
            
        }
    }
    
    private func mapAvailableImages(from sprite: Sprites) {
        onImageCheckCompleted?(sprite.allSprites)
    }
}

extension PokemonViewModel {
    var name: String? {
        fetchedPokemon?.name.capitalized
    }
    
    var id: String? {
        "#\(fetchedPokemon?.id ?? 0)"
    }
    
    var type: String? {
        fetchedPokemon?.types.first?.type.name.capitalized
    }
    
    var backgroundColor: RGB? {
        fetchedPokemon?.types.first?.typeID()?.rgbColor
    }
    
    var stats: String? {
        fetchedPokemon?.stats.map { $0.stat.name }.joined(separator: ", ").capitalized
    }
    
    var abilities: String? {
        fetchedPokemon?.abilities.map { $0.ability.name }.joined(separator: ", ").capitalized
    }
}
