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
    let listLoader: RemoteListLoader
    let pokemonLoader: RemotePokemonLoader
    let idProvider: IDProvider
    
    public init(listLoader: RemoteListLoader, pokemonLoader: RemotePokemonLoader, idProvider: IDProvider) {
        self.listLoader = listLoader
        self.pokemonLoader = pokemonLoader
        self.idProvider = idProvider
    }
    
    public func load(completion: @escaping (Result<ChosenPokemon, Error>) -> Void) {
        listLoader.load(from: .list) { listResult in
            switch listResult {
            case let .success(list):
                let id = idProvider.generateID(from: 1, to: list.count)
                
                pokemonLoader.load(from: .pokemon(id)) { pokemonResult in
                    switch pokemonResult {
                    case let .success(pokemon):
                        completion(.success(pokemon.chosen))
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

extension PokemonItem {
    var chosen: ChosenPokemon {
        ChosenPokemon(id: id, name: name)
    }
}
