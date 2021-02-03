//
//  RemoteChosenPokemonLoader.swift
//  PokeWidgetEngine
//
//  Created by Vinicius Moreira Leal on 31/01/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import Foundation
import PokemonDomain

public struct RemoteChosenPokemonLoader {
    public typealias Result = Swift.Result<ChosenPokemon, Error>
    
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
    
    // TODO: Semaphores?
    public func load(completion: @escaping (Result) -> Void) {
        listLoader.load(from: .list) { listResult in
            switch listResult {
            case let .success(list):
                let id = idProvider.generateID(from: 1, to: list.count)
                
                pokemonLoader.load(from: .pokemon(id)) { pokemonResult in
                    switch pokemonResult {
                    case let .success(pokemon):
                        loadImage(for: pokemon, completion: completion)
                        
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func spriteURL(from pokemon: PokemonItem) -> URL? {
        pokemon.sprites.frontDefault?.asURL ?? pokemon.sprites.allSprites.first?.asURL
    }
    
    private func loadImage(for pokemon: PokemonItem, completion: @escaping (Result) -> Void) {
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
    
    private func completeWith(_ pokemon: PokemonItem, imageData: Data? = nil, completion: @escaping (Result) -> Void) {
        completion(.success(ChosenPokemon(id: pokemon.id, name: pokemon.name, imageData: imageData ?? .emptyData)))
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
