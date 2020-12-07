//
//  PokemonViewModel.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 29/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

public class PokemonViewModel {

    // MARK: - Properties

    let pokemonID: String
    var loader: RemotePokemonLoader
    
    var onFetchCompleted: ((PokemonItem) -> Void)?
    var onFetchFailed: ((String) -> Void)?

    var imagesAvailable = [String]() {
        didSet {
            // Post notification for 'PhotoCarousel' and 'PhotoIndicator'
            NotificationCenter.default.post(name: .saveImagesUrlAvailable, object: self)
        }
    }

    // MARK: - Initializer

    public init(loader: RemotePokemonLoader, pokemonID: String) {
        self.loader = loader
        self.pokemonID = pokemonID
    }

    // MARK: - API

    func fetchPokemon() {
        loader.load(from: URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonID)")!) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case .success(let pokemon):
                    self.imagesAvailable = self.checkForAvailableImages(pokemon.sprites)
                    
                    self.onFetchCompleted?(pokemon)
                case .failure(let error):
                    
                    self.onFetchFailed?(error.localizedDescription)
            }
            
        }
    }
    
    private func checkForAvailableImages(_ sprite: Sprites) -> [String] {
        [sprite.frontDefault,
         sprite.frontFemale,
         sprite.frontShiny,
         sprite.frontShinyFemale,
         sprite.backDefault,
         sprite.backFemale,
         sprite.backShiny,
         sprite.backShinyFemale]
            .compactMap { $0 }
    }
}
