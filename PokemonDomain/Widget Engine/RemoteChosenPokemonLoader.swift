//
//  RemoteChosenPokemonLoader.swift
//  PokeWidgetEngine
//
//  Created by Vinicius Moreira Leal on 31/01/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//  Kleisi composition reference: https://swiftrocks.com/avoiding-callback-hell-in-swift

import Foundation

public struct RemoteChosenPokemonLoader {
    let listLoader: RemoteListLoader
    let pokemonLoader: RemotePokemonLoader
    let imageDataLoader: RemoteImageDataLoader
    let idProvider: IDProvider
    
    public init(listLoader: RemoteListLoader, pokemonLoader: RemotePokemonLoader, imageDataLoader: RemoteImageDataLoader, idProvider: IDProvider) {
        self.listLoader = listLoader
        self.pokemonLoader = pokemonLoader
        self.imageDataLoader = imageDataLoader
        self.idProvider = idProvider
    }
    
    public func load(completion: ((ChosenPokemon) -> Void)?) {
        let loadPipeline = loadRandomID >>->> loadPokemon >>->> loadImage
        loadPipeline?(.list, completion)
    }
    
    private func loadRandomID(from list: URL, completion: ((Int) -> Void)?) {
        listLoader.load(from: .list) { listResult in
            if let list = try? listResult.get() {
                let id = idProvider.generateID(upTo: list.count)
                completion?(id)
            }
        }
    }
    
    private func loadPokemon(with id: Int, completion: ((PokemonItem) -> Void)?) {
        pokemonLoader.load(from: .pokemon(id)) { pokemonResult in
            if let pokemon = try? pokemonResult.get() {
                completion?(pokemon)
            }
        }
    }
    
    private func loadImage(for pokemon: PokemonItem, completion: ((ChosenPokemon) -> Void)?) {
        guard let spriteURL = spriteURL(from: pokemon) else {
            return completeWith(pokemon, completion: completion)
        }
        
        imageDataLoader.load(from: spriteURL) { imageDataResult in
            switch imageDataResult {
            case let .success(imageData):
                completeWith(pokemon, imageData: imageData, completion: completion)
            case .failure:
                completeWith(pokemon, completion: completion)
            }
        }
    }
    
    private func spriteURL(from pokemon: PokemonItem) -> URL? {
        pokemon.sprites.frontDefault?.asURL ?? pokemon.sprites.allSprites.first?.asURL
    }
    
    private func completeWith(_ pokemon: PokemonItem, imageData: Data? = nil, completion: ((ChosenPokemon) -> Void)?) {
        completion?(ChosenPokemon(id: pokemon.id, name: pokemon.name, imageData: imageData ?? .emptyData))
    }
}

private extension String {
    var asURL: URL? {
        URL(string: self)
    }
}

private extension Data {
    static var emptyData: Data {
        Data()
    }
}

private extension URL {
    static var list: URL {
        URL(string: "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=1")!
    }
    
    static func pokemon(_ id: Int) -> URL {
        URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)/")!
    }
}
