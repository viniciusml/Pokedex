//
//  RemoteChosenPokemonLoader.swift
//  PokeWidgetExtension
//
//  Created by Vinicius Moreira Leal on 24/01/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import Foundation
import PokemonDomain

struct RemoteChosenPokemonLoader {
    let listLoader: RemoteListLoader
    let pokemonLoader: RemotePokemonLoader
    
    func load(completion: @escaping (Result<Int, Error>) -> Void) {
        loadList { listResult in
            switch listResult {
            case let .success(count):
                let pokemonID = Int.random(in: 1...count)
                
                pokemonLoader.load(from: .pokemon(pokemonID)) { pokemonResult in
                    
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func loadList(completion: @escaping (Result<Int, Error>) -> Void) {
        listLoader.load(from: .list) { result in
            switch result {
            case let .success(list):
                completion(.success(list.count))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

enum Endpoint {
    case list
    case pokemon(Int)
    
    var url: URL {
        switch self {
        case .list: return URL(string: "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=10")!
        case .pokemon(let id): return URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)/")!
        }
    }
}

extension URL {
    static var list: URL {
        Endpoint.list.url
    }
    
    static func pokemon(_ id: Int) -> URL {
        Endpoint.pokemon(id).url
    }
}
