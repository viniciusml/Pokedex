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
        case invalidData
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> ListItem {
        guard response.isOK, let list = try? JSONDecoder().decode(ListItem.self, from: data) else {
            throw Error.invalidData
        }
        
        return list
    }
}
