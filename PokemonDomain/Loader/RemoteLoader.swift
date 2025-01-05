//
//  ListLoader.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 26/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

/// Network Service.
open class RemoteLoader<Resource> {
    private let client: HTTPClient
    private let mapper: Mapper
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = Swift.Result<Resource, Error>
    public typealias Mapper = (Data) throws -> Resource
    
    public init(client: HTTPClient, mapper: @escaping Mapper) {
        self.client = client
        self.mapper = mapper
    }
    
    open func load(from url: URL, completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success((let data, let response)) where response.isOK:
                self.map(data, completion: completion)
                
            case .success:
                completion(.failure(.invalidData))
                
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
    
    private func map(_ data: Data, completion: @escaping (Result) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            do {
                let mapped = try mapper(data)
                
                DispatchQueue.main.async {
                    completion(.success(mapped))
                }
            } catch {
                
                DispatchQueue.main.async {
                    completion(.failure(.invalidData))
                }
            }
        }
    }
}
