//
//  ChosenPokemon.swift
//  PokeWidgetEngine
//
//  Created by Vinicius Moreira Leal on 31/01/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

public struct ChosenPokemon: Equatable {
    public let id: Int
    public let name: String
    public let imageData: Data
    
    public init(id: Int, name: String, imageData: Data) {
        self.id = id
        self.name = name
        self.imageData = imageData
    }
}
