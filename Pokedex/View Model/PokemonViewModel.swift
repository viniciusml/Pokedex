//
//  PokemonViewModel.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 29/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

protocol PokemonViewModelDelegate: class {
    func onFetchCompleted(pokemon: PokemonItem)
    func onFetchFailed(with reason: String)
}

class PokemonViewModel {

    // MARK: - Properties

    let pokemonID: String

    let client = AFHTTPClient()

    var loader: RemoteLoader<PokemonItem> {
        RemoteLoader(client: client, mapper: PokemonItemMapper.map)
    }

    var imagesAvailable = [String]() {
        didSet {
            // Post notification for 'PhotoCarousel' and 'PhotoIndicator'
            NotificationCenter.default.post(name: .saveImagesUrlAvailable, object: self)
        }
    }

    weak var pokemonDelegate: PokemonViewModelDelegate?

    // MARK: - Initializer

    init(pokemonID: String, delegate: PokemonViewModelDelegate) {
        self.pokemonID = pokemonID
        self.pokemonDelegate = delegate
    }

    // MARK: - API

    func fetchPokemon() {

//        loader.loadPokemon(pokemonId: pokemonID) { [weak self] result in
//            guard let self = self else { return }
//
//            switch result {
//            case .success(let pokemon):
//                self.imagesAvailable = self.checkForAvailableImages(pokemon.sprites)
//
//                DispatchQueue.main.async {
//                    // Inform delegate data about repository detail
//                    self.pokemonDelegate?.onFetchCompleted(pokemon: pokemon)
//                }
//
//            case .failure(let error):
//
//                DispatchQueue.main.async {
//                    // Inform delegate the motive of failure
//                    self.pokemonDelegate?.onFetchFailed(with: error.localizedDescription)
//                }
//
//            }
//        }
    }

    // Removes 'nil' properties from the array.
    private func checkForAvailableImages(_ sprite: Sprites) -> [String] {
        let sprites = [sprite.frontDefault, sprite.frontFemale, sprite.frontShiny, sprite.frontShinyFemale, sprite.backDefault, sprite.backFemale, sprite.backShiny, sprite.backShinyFemale]
        return sprites.compactMap { $0 }

    }
}
