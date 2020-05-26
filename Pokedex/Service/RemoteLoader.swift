//
//  ListLoader.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 26/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

public protocol ListLoader {
    func load(completion: @escaping (RequestResult<ListItem>) -> Void)
}

// MARK: - Generic Request Result
/// Result received from a request.
///
/// When request and mapping are successful, delivers a Generic Decodable type.
/// When request or mapping are unsuccessful, delivers an Error type.
public typealias RequestResult<T: Decodable> = Result<T, NetworkError>

public enum NetworkError: Error {
    case connectivity
    case invalidData
}

/// Network Service.
public class RemoteLoader {

    //    MARK: - Properties

    let client: NetworkAdapter

    // MARK: - Initializer

    public init(client: NetworkAdapter) {
        self.client = client
    }

    public func loadResourceList(page: String = "0", completion: @escaping (RequestResult<ListItem>) -> Void) {

        let offset = "https://pokeapi.co/api/v2/pokemon/?offset=\(page)&limit=40"

        client.load(ListItem.self, from: offset) { result in
            switch result {
            case let .success(listItem):
                completion(.success(listItem))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }

    public func loadPokemon(pokemonId: String = "", completion: @escaping (RequestResult<PokemonItem>) -> Void) {

        let urlString = "https://pokeapi.co/api/v2/pokemon/\(pokemonId)"

        client.load(PokemonItem.self, from: urlString) { result in
            switch result {
            case let .success(pokemonItem):
                completion(.success(pokemonItem))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
