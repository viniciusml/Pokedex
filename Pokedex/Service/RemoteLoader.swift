//
//  ListLoader.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 26/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

public protocol ListLoader {
    func load(completion: @escaping (RequestResult<[ResultItem]>) -> Void)
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


public final class ListItemMapper {
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> ListItem {
        guard response.isOK, let list = try? JSONDecoder().decode(ListItem.self, from: data) else {
            throw Error.invalidData
        }
        
        return list
    }
}

public final class PokemonItemMapper {
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> PokemonItem {
        guard response.isOK, let item = try? JSONDecoder().decode(PokemonItem.self, from: data) else {
            throw Error.invalidData
        }
        
        return item
    }
}

/// Network Service.
public class RemoteLoader<Resource> {
    
//    public func loadResourceList(page: String = "0", completion: @escaping (RequestResult<ListItem>) -> Void) {
//
//        let offset = "https://pokeapi.co/api/v2/pokemon/?offset=\(page)&limit=40"
//
//        client.load(ListItem.self, from: offset) { result in
//            switch result {
//            case let .success(listItem):
//                completion(.success(listItem))
//            case .failure:
//                completion(.failure(.connectivity))
//            }
//        }
//    }
//
//    public func loadPokemon(pokemonId: String = "", completion: @escaping (RequestResult<PokemonItem>) -> Void) {
//
//        let urlString = "https://pokeapi.co/api/v2/pokemon/\(pokemonId)"
//
//        client.load(PokemonItem.self, from: urlString) { result in
//            switch result {
//            case let .success(pokemonItem):
//                completion(.success(pokemonItem))
//            case .failure:
//                completion(.failure(.connectivity))
//            }
//        }
//    }

    private let client: HTTPClient
    private let mapper: Mapper
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = Swift.Result<Resource, Swift.Error>
    public typealias Mapper = (Data, HTTPURLResponse) throws -> Resource
    
    public init(client: HTTPClient, mapper: @escaping Mapper) {
        self.client = client
        self.mapper = mapper
    }
    
    public func load(from url: URL, completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case let .success((data, response)):
                    completion(self.map(data, from: response))
                    
                case .failure:
                    completion(.failure(Error.connectivity))
            }
        }
    }
    
    private func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            return .success(try mapper(data, response))
        } catch {
            return .failure(Error.invalidData)
        }
    }
}
