//
//  PokemonItemMapper.swift
//  Pokedex
//
//  Created by Vinicius Leal on 25/10/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

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
