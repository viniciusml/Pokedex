//
//  PokemonViewModel.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 29/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

public class PokemonViewModel {

    // MARK: - Properties

    private let pokemonURLString: String
    private let loader: RemotePokemonLoader
    private var fetchedPokemon: PokemonItem?
    
    var onFetchCompleted: ((PokemonViewModel) -> Void)?
    var onFetchFailed: (() -> Void)?

    var imagesAvailable = [String]() {
        didSet {
            // Post notification for 'PhotoCarousel' and 'PhotoIndicator'
            NotificationCenter.default.post(name: .saveImagesUrlAvailable, object: self)
        }
    }

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
                    self.imagesAvailable = self.checkForAvailableImages(pokemon.sprites)
                    self.fetchedPokemon = pokemon
                    self.onFetchCompleted?(self)
                case .failure:
                    
                    self.onFetchFailed?()
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
    
    // TODO: Remove UIKit
    var backgroundColor: UIColor? {
        fetchedPokemon?.types.first?.typeID()?.color
    }
    
    var stats: String? {
        fetchedPokemon?.stats.map { $0.stat.name }.joined(separator: ", ").capitalized
    }
    
    var abilities: String? {
        fetchedPokemon?.abilities.map { $0.ability.name }.joined(separator: ", ").capitalized
    }
}
