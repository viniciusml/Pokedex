//
//  ListItemMapper.swift
//  Pokedex
//
//  Created by Vinicius Leal on 25/10/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

public final class ListItemMapper {
    public enum Error: Swift.Error {
        case decodingError
    }
    
    public static func map(_ data: Data) throws -> ListItem {
        guard let list = try? JSONDecoder().decode(ListItem.self, from: data) else {
            throw Error.decodingError
        }
        
        return list
    }
}
