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
        case decodingError
    }
    
    public static func map(_ data: Data) throws -> PokemonItem {
        guard let item = try? JSONDecoder().decode(PokemonItem.self, from: data) else {
            throw Error.decodingError
        }
        
        return item
    }
}
