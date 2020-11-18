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

/// Network Service.
public class RemoteLoader<Resource> {
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
    
    public func load(from url: URL, completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success((let data, let response)) where response.isOK:
                    completion(self.map(data))
                    
                case .success:
                    completion(.failure(Error.invalidData))
                    
                case .failure:
                    completion(.failure(Error.connectivity))
            }
        }
    }
    
    private func map(_ data: Data) -> Result {
        do {
            return .success(try mapper(data))
        } catch {
            return .failure(Error.invalidData)
        }
    }
}
