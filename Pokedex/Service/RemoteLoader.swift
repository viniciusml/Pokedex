//
//  ListLoader.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 26/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

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

    // Generic 'Load' function.
    private func load<U: Decodable>(parameter: String, completion: @escaping (RequestResult<U>) -> Void) {

        let urlString = "https://pokeapi.co/api/v2/pokemon/\(parameter)"

        client.load(from: urlString) { result in
            switch result {
            case let .success(data, response):
                if response.statusCode == 200, let item = try? JSONDecoder().decode(U.self, from: data) {
                    completion(.success(item))
                } else {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }

    public func loadResourceList(page: String = "0", completion: @escaping (RequestResult<ListItem>) -> Void) {
        let offset = "?offset=\(page)&limit=40"
        load(parameter: offset, completion: completion)
    }

    public func loadPokemon(pokemonId: String = "", completion: @escaping (RequestResult<PokemonItem>) -> Void) {
        load(parameter: pokemonId, completion: completion)
    }
}
