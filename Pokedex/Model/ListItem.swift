//
//  ListItem.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 25/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

// MARK: - Resource Item
public struct ListItem: Decodable, Equatable {
    public let count: Int
    public let next: String
    public let previous: String?
    public let results: [ResultItem]
    
    public init(count: Int, next: String, previous: String?, results: [ResultItem]) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
}

// MARK: - Result
public struct ResultItem: Decodable, Equatable {
    public let name: String
    public let url: String
    
    public init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}
