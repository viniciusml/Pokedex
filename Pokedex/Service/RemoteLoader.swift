//
//  ListLoader.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 26/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

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
                guaranteeMainThread {
                    completion(self.map(data))
                }
                
            case .success:
                guaranteeMainThread {
                    completion(.failure(.invalidData))
                }
                
            case .failure:
                guaranteeMainThread {
                    completion(.failure(.connectivity))
                }
            }
        }
    }
    
    private func map(_ data: Data) -> Result {
        do {
            return .success(try mapper(data))
        } catch {
            return .failure(.invalidData)
        }
    }
}

fileprivate func guaranteeMainThread(_ work: @escaping () -> Void) {
    if Thread.isMainThread {
        work()
    } else {
        DispatchQueue.main.async(execute: work)
    }
}
