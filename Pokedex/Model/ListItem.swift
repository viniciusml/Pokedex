//
//  ListItem.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 25/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

// MARK: - Resource Item
struct ListItem: Codable {
    let count: Int
    let next: String
    let previous: String?
    let results: [ResultItem]
}

// MARK: - Result
struct ResultItem: Codable {
    let name: String
    let url: String
}
