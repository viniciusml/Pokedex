//
//  ListLoader.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 26/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

public class RemoteLoader {
    
    let client: NetworkAdapter
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias RequestResult<T: Decodable> = Result<T, Error>
    
    public init(client: NetworkAdapter) {
        self.client = client
    }
    
    public func load<U: Decodable>(completion: @escaping (RequestResult<U>) -> Void) {
        
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
        
        client.load(from: url) { result in
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
    
    public func loadResourceList(completion: @escaping (RequestResult<ListItem>) -> Void) {
        load(completion: completion)
    }
}
