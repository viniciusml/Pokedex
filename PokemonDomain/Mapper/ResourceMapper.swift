//
//  ResourceMapper.swift
//  Pokedex
//
//  Created by Vinicius Leal on 28/10/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

public final class ResourceMapper<Resource: Decodable> {
    public enum Error: Swift.Error {
        case decodingError
    }
    
    public static func map(_ data: Data) throws -> Resource {
        guard let resource = try? JSONDecoder().decode(Resource.self, from: data) else {
            throw Error.decodingError
        }
        
        return resource
    }
}
