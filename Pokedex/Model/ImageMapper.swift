//
//  ImageMapper.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 01/01/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

public final class ImageMapper {
    public enum Error: Swift.Error {
        case imageCreationError
    }
    
    public static func map(_ data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw Error.imageCreationError
        }
        
        return image
    }
}
