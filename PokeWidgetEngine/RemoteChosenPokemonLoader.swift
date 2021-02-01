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
                        
                        if let frontDefault = pokemon.sprites.frontDefault,
                           let frontDefaultURL = URL(string: frontDefault) {
                            
                            imageDataLoader.load(from: frontDefaultURL) { imageDataResult in
                                if let imageData = try? imageDataResult.get() {
                                    completion(.success(ChosenPokemon(id: pokemon.id, name: pokemon.name, imageData: imageData)))
                                } else {
                                    completion(.success(ChosenPokemon(id: pokemon.id, name: pokemon.name, imageData: Data())))
                                }
                            }
                        } else if let urlString = pokemon.sprites.frontShiny,
                                          let url = URL(string: urlString) {
                            
                            imageDataLoader.load(from: url) { imageDataResult in
                                if let imageData = try? imageDataResult.get() {
                                    completion(.success(ChosenPokemon(id: pokemon.id, name: pokemon.name, imageData: imageData)))
                                } else {
                                    completion(.success(ChosenPokemon(id: pokemon.id, name: pokemon.name, imageData: Data())))
                                }
                            }
                        } else {
                            completion(.success(ChosenPokemon(id: pokemon.id, name: pokemon.name, imageData: Data())))
                        }
                        
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

extension URL {
    static var list: URL {
        URL(string: "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=1")!
    }
    
    static func pokemon(_ id: Int) -> URL {
        URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)/")!
    }
}

public typealias RemoteImageDataLoader = RemoteLoader<Data>

extension RemoteImageDataLoader {
    public convenience init(client: HTTPClient) {
        self.init(client: client, mapper: DataMapper.map)
    }
}

public struct DataMapper {
    public static func map(_ data: Data) throws -> Data { data }
}
