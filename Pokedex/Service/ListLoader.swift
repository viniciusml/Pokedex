//
//  ListLoader.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 26/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

public class ListLoader {
    let client: NetworkAdapter
    let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias ListResult = Result<ListItem, Error>
    
    public init(url: URL, client: NetworkAdapter) {
        self.client = client
        self.url = url
    }
    
    public func loadResourceList(completion: @escaping (ListResult) -> Void) {
        client.load(from: url) { result in
            switch result {
            case .success:
                completion(.failure(.invalidData))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
